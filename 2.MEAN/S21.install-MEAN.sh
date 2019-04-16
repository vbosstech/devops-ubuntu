#!/bin/bash
# -------
# Script to configure and setup Nginx, NVM, PM2, Nodejs, Redis, MongoDB, Jenkins, CertbotSSL, pip, mkdocs, jekyll, gasby
#
# -------

# Configure constants
if [ -f "constants.sh" ]; then
  . constants.sh
fi

# Configure colors
if [ -f "colors.sh" ]; then
  . colors.sh
fi

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echogreen "Begin running...."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo


URLERROR=0

for REMOTE in $NVMURL $NODEJSURL
do
        wget --spider $REMOTE --no-check-certificate >& /dev/null
        if [ $? != 0 ]
        then
                echored "Please fix this URL: $REMOTE and try again later"
                URLERROR=1
        fi
done

if [ $URLERROR = 1 ]
then
    echo
    echored "Please fix the above errors and rerun."
    echo
    exit
fi

# Create temporary folder for storing downloaded files
if [ ! -d "$TMP_INSTALL" ]; then
  mkdir -p $TMP_INSTALL
fi


######
# NVM
######
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

##
# Node JS
##
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Begin setting up a nodejs..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install nodejs${ques} [y/n] " -i "$DEFAULTYESNO" installnodejs
if [ "$installnodejs" = "y" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "Installing & Configuring NodeJS LTS (v$NODEJS_LAMBDA)"
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  nvm install $NODEJS_LAMBDA
  nvm use $NODEJS_LAMBDA
  nvm alias default $NODEJS_LAMBDA
  # curl -sL $NODEJSURL | sudo -E bash -
  # sudo apt-get $APTVERBOSITY install nodejs
  # npm install -g npm@latest
  # [Optional] Some NPM packages will probably throw errors when compiling
  # sudo apt-get $APTVERBOSITY install build-essential
fi

##
# PM2
##
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Begin setting up a PM2..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install PM2${ques} [y/n] " -i "$DEFAULTYESNO" installpm2
if [ "$installpm2" = "y" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "You need to install PM2"
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"

  ### Ubuntu User
  # npm install -g pm2
  ## TODO: permission-startup.sh
  # mkdir /home/$USER/.pm2
  # sudo chown $USER:$USER -R /home/$USER/.pm2
  # sudo env PATH=$PATH:/usr/bin /home/ubuntu/.nvm/versions/node/v8.10.0/bin/pm2 startup systemd -u $USER --hp /home/$USER

  ### Manually Install
  ### Run as root (need pm2 for jenkins)
  # sudo -i
  # curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
  # sudo apt-get install -y nodejs
  npm install -g pm2
  pm2 startup
  ## pm2 metrics, need link as jenkins
  # TODO
  # sudo -i
  # su - jenkins
  # pm2 link iqghptportzkkb4 1rm35zi9twrzho0

  n=$(which node);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local
  # n=$(which pm2);n=${n%/bin/node}; chmod -R 755 $n/bin/*; sudo cp -r $n/{bin,lib,share} /usr/local
fi

##
# Redis
##
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Begin setting up a Redis..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install Redis${ques} [y/n] " -i "$DEFAULTYESNO" installredis
if [ "$installredis" = "y" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "You need to install Redis"
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  sudo apt-get $APTVERBOSITY install redis-server
  echo "maxmemory 2048mb" | sudo tee --append /etc/redis/redis.conf
    echo "maxmemory-policy allkeys-lru" | sudo tee --append /etc/redis/redis.conf
  sudo systemctl enable redis-server.service
fi

##
# MongoDB
##
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Begin setting up a MongoDB..."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Install MongoDB${ques} [y/n] " -i "$DEFAULTYESNO" installmongodb
if [ "$installmongodb" = "y" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "You need to install MongoDB"
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  
  # Import the key for the official MongoDB repository
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
  
    # Create a list file for MongoDB
    echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
  
    sudo apt-get $APTVERBOSITY update
  
    # Install mongodb-org, which includes the daemon, configuration and init scripts, shell, and management tools on the server. 
    sudo apt-get $APTVERBOSITY install -y mongodb-org
  
    # Ensure that MongoDB restarts automatically at boot
    sudo systemctl enable mongod   
    sudo systemctl start mongod
    # sudo service mongod restart
fi

### Verify the MEAN
node -v                      
npm -v                       
pm2 list                     
redis-server -v              
mongo -version  