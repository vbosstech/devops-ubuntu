#!/bin/bash
# -------
# Ubuntu 16.04 Scripts to check and initialize all necessary stuffs before running DevOps
# -------

# Configure constants
if [ -f "constants.sh" ]; then
	. constants.sh
fi

# Configure colors
if [ -f "colors.sh" ]; then
	. colors.sh
fi

# Create temporary folder for storing downloaded files
if [ ! -d "$TMP_INSTALL" ]; then
  mkdir -p $TMP_INSTALL
fi

# size of swapfile in megabytes = 2X
# default is 2*1G 
swapsize=2G

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Preparing for install. Updating and upgrading the apt package index files..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
sudo apt-get $APTVERBOSITY update && sudo apt-get $APTVERBOSITY upgrade;
echo

######################################################
# Swap File
######################################################
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Starting to create Swap space..."
echo "Swap space/partition is space on a disk created for use by the operating system when memory has been fully utilized." 
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
	echo "swapfile not found. Adding swapfile. Swap should be double the amount of 16GB RAM"
	sudo fallocate -l ${swapsize} /swapfile
	sudo chmod 600 /swapfile
	sudo mkswap /swapfile
	sudo swapon /swapfile

  # Back up the /etc/fstab
  sudo cp /etc/fstab /etc/fstab.bak
  echo '/swapfile none swap sw 0 0' | sudo tee --append /etc/fstab
  echo "vm.swappiness=20"           | sudo tee --append /etc/sysctl.conf
  echo "vm.vfs_cache_pressure=60"   | sudo tee --append /etc/sysctl.conf
else
	echo "swapfile already exists. Skipping adding swapfile."
fi


echo "Showing swap info....."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# output results to terminal
# cat /proc/swaps
# cat /proc/meminfo | grep Swap
free -h
sudo swapon --show
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

sudo locale-gen $LOCALESUPPORT
sudo update-locale LC_ALL=$LOCALESUPPORT
# sudo dpkg-reconfigure locales
# sudo echo "LC_ALL=en_US.UTF-8" >> /etc/environment
# sudo echo "LANG=en_US.UTF-8" >> /etc/environment

######################################################
# Timezone
######################################################
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Begin setting up TimeZone..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
sudo timedatectl set-timezone $TIME_ZONE


if [ "`which curl`" = "" ]; then
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	echo "You need to install curl. Curl is used for downloading components to install."
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sudo apt-get $APTVERBOSITY install curl;
fi

if [ "`which wget`" = "" ]; then
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	echo "You need to install wget. Wget is used for downloading components to install."
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sudo apt-get $APTVERBOSITY install wget;
fi

if [ "`which rsync`" = "" ]; then
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	echo "You need to install rsync. rsync is used for copying or synchronizing data in local or remote ."
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sudo apt-get $APTVERBOSITY install rsync;
fi

if [ "`which zip`" = "" ]; then
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	echo "You need to install zip. zip is used for compressing data."
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sudo apt-get $APTVERBOSITY install zip;
fi

if [ "`which unzip`" = "" ]; then
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	echo "You need to install unzip. unzip is used for uncompressing data ."
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sudo apt-get $APTVERBOSITY install unzip;
fi

if [ "`which git`" = "" ]; then
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	echo "You need to install git."
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sudo apt-get $APTVERBOSITY install git;
	sudo chown -R $USER:$USER ~/.config
fi


######################################################
# Nginx
######################################################
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Nginx can be used as reverse proxy."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install nginx${ques} [y/n] " -i "$DEFAULTYESNO" installnginx
if [ "$installnginx" = "y" ]; then

  # Remove nginx if already installed
  if [ "`which nginx`" != "" ]; then
   sudo apt-get remove --auto-remove nginx nginx-common
   sudo apt-get purge --auto-remove nginx nginx-common
  fi
  echoblue "Installing nginx. Fetching packages..."
  echo

  sudo apt-get $APTVERBOSITY update
  sudo apt-get $APTVERBOSITY install nginx
  
  # Enable Nginx to auto start when Ubuntu is booted
  sudo systemctl enable nginx
  ## Reload config file
  sudo systemctl restart nginx

  echo
  echogreen "Finished installing nginx"
  sudo nginx -t 
  echo
else
  echo "Skipping install of nginx"
fi

echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Installing ufw"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
sudo ufw enable
sudo ufw allow 80
sudo ufw allow 443
sudo ufw allow 22
sudo ufw status numbered
sudo service nginx status   

#############################
# Docker & Docker-Compose
#############################
if [ "`which docker`" = "" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "You need to install Docker & Docker-Compose"
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  sudo curl -fsSL get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod u+x /usr/local/bin/docker-compose
  sudo groupadd docker
  sudo usermod -aG docker $USER
  sudo service docker restart
fi

#############################
# NVM
#############################
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Begin setting up a nvm..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install nvm${ques} [y/n] " -i "$DEFAULTYESNO" installnvm
if [ "$installnvm" = "y" ]; then
  sudo curl -# -o $TMP_INSTALL/install.sh $NVMURL
  sudo sh $TMP_INSTALL/install.sh
  echo 'export NVM_DIR="$HOME/.nvm"' | sudo tee --append ~/.bashrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' | sudo sudo tee --append $HOME/.bashrc
  sudo chown $USER:$USER -R $HOME/.nvm
  source $HOME/.bashrc
  echo
  echogreen "Finished installing NVM"
fi

## Yarn
echogreen "Installing Yarn"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn

## Python ###
echogreen "Installing Python"
if [ "`which python`" = "" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "You need to install python."
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  sudo apt-get $APTVERBOSITY install python
fi

## Pip ###
echogreen "Installing Pip"
if [ "`which pip`" = "" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "You need to install python pip."
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  sudo apt-get $APTVERBOSITY install python-pip
  sudo pip install --upgrade pip
  # sudo pip install awscli --upgrade --user
fi

if [ "`which aws`" = "" ]; then
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	echo "You need to install awscli."
	echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sudo apt-get $APTVERBOSITY install awscli
fi


##############################
# Remote login
##############################
# read -e -p "Do you want to ssh to server remotely by providing username and password${ques} [y/n] " -i "$DEFAULTYESNO" sshremote
# if [ "$sshremote" = "y" ]; then
# 	sudo sed -i "s/\(^PasswordAuthentication \).*/\1yes/" /etc/ssh/sshd_config
# 	sudo service sshd restart
# 	sudo usermod --password $(echo PASSWORD | openssl passwd -1 -stdin) $USER
# 	echogreen "User can ssh to server by using this command : ssh -o PreferredAuthentications=password user@ip"
# fi


##
# Certbot SSL
##
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Certbot SSL"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install certbot${ques} [y/n] " -i "$DEFAULTYESNO" installcertbot
if [ "$installcertbot" = "y" ]; then

  # Insert config for letsencrypt
  if [ ! -d "/opt/letsencrypt/.well-known" ]; then
  sudo mkdir -p /opt/letsencrypt/.well-known
  echo "Hello Letsencrypt!" | sudo tee /opt/letsencrypt/index.html
  fi
  
  sudo chown -R www-data:root /opt/letsencrypt
  
  if [ -f "/etc/nginx/sites-available/default" ]; then
      # Check if eform config does exist
    well_known=$(grep -o "well-known" /etc/nginx/sites-available/default | wc -l)
    
    if [ $well_known = 0 ]; then
       sudo sed -i '/^\(}\)/ i location \/\.well-known {\n  alias \/opt\/letsencrypt\/\.well-known\/;\n  allow all;  \n  }' /etc/nginx/sites-available/default
     fi
  fi
  
  if [ ! -f "/etc/nginx/snippets/ssl.conf" ]; then
  sudo echo "
ssl_session_timeout 1d;
ssl_session_cache shared:SSL:50m;
ssl_session_tickets off;

ssl_protocols TLSv1.2;
ssl_ciphers EECDH+AESGCM:EECDH+AES;
ssl_ecdh_curve secp384r1;
ssl_prefer_server_ciphers on;

ssl_stapling on;
ssl_stapling_verify on;

add_header Strict-Transport-Security \"max-age=15768000; includeSubdomains; preload\";
add_header X-Content-Type-Options nosniff;
" | sudo tee /etc/nginx/snippets/ssl.conf
  fi

  ### domain.txt
  count=1
  while read line || [[ -n "$line" ]] ;
  do
    count=`expr $count + 1`
    if [ $count -gt 3 ]; then
      IFS='|' read -ra arr <<<"$line"
      port="$(echo -e "${arr[3]}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
      if [[ $port =~ '^[0-9]+$' ]]; then
        sudo ufw allow $port
      fi
    fi
  done < $BASE_INSTALL/domain.txt

  # Remove nginx if already installed
  if [ "`which certbot`" != "" ]; then
    # Uninstall Certbot
    sudo apt-get purge python-certbot-nginx
    sudo rm -rf /etc/letsencrypt
  fi
  echoblue "Installing Certbot. Fetching packages..."
  echo  
  sudo apt-get $APTVERBOSITY update
  sudo apt-get $APTVERBOSITY install software-properties-common python-software-properties
  sudo add-apt-repository universe
  sudo add-apt-repository ppa:certbot/certbot
  sudo apt-get $APTVERBOSITY update
  sudo apt-get $APTVERBOSITY install python-certbot-nginx 

  sudo certbot --nginx
  # sudo certbot --nginx certonly
  sudo certbot renew --dry-run

  echo
    echogreen "Finished installing Certbot"
  echo

  ## Automatically Renew Certbot
  if [ ! -f "/etc/cron.daily/renewcerts" ]; then
  sudo echo "
  #!/bin/bash
  certbot renew
  service nginx reload
  " | sudo tee /etc/cron.daily/renewcerts
  fi
  sudo chmod a+x /etc/cron.daily/renewcerts
  echogreen "Finished Automatically Renew Certbot"

  # sudo certbot renew
  sudo certbot renew --dry-run
  run-parts --test -v /etc/cron.daily
else
  echo "Skipping install of Certbot"
fi


##############################
## Verify the installation
##############################
echogreen "Verify the Installation"

lsb_release -a               
timedatectl                  
free -h                      
# sudo swapon --show

# pip --version
# python --version     
# java -version                
# sudo systemctl status jenkins 

sudo docker volume ls
# sudo docker volume prune