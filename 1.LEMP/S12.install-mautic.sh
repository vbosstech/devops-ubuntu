#!/bin/bash
# Configure and install ocr services
######

# Configure constants
if [ -f "constants.sh" ]; then
  . constants.sh
else
  . ../constants.sh
fi

# Configure colors
if [ -f "colors.sh" ]; then
  . colors.sh
else
  . ../colors.sh  
fi

# export BASE_WP=~
export WEBSERVER_PATH=/var/www
export MARKETING_USER=marketing
export MARKETING_RELEASE=2.15.1

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echogreen "Begin running...."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo

## @FIXME using AWS RDS instead of
# if [ "$(which mysql)" = "" ]; then
#   . $BASE_INSTALL/scripts/mariadb.sh
# fi
  
# cd $BASE_WP
cd $WEBSERVER_PATH

if [ -d "/var/www/$MARKETING_USER" ]; then
  sudo rm -rf /var/www/$MARKETING_USER
fi

if [ ! -d "$WEBSERVER_PATH/$MARKETING_USER" ]; then
  git clone https://vbosstech@github.com/vbosstech/MARKETING_.git --branch $MARKETING_RELEASE $WEBSERVER_PATH/$MARKETING_USER
else
  cd $WEBSERVER_PATH/$MARKETING_USER
  git pull
fi

# sudo chown -R www-data:www-data /var/www/$MARKETING_USER
sudo find . -type d -exec chmod 755 {} \;
sudo find . -type f -exec chmod 644 {} \;
sudo chown -R $USER:www-data .
# sudo php app/console cache:clear --env=prod
cd $WEBSERVER_PATH/$MARKETING_USER
# sudo rsync -avz README/$MARKETING_USER/ /var/www/$MARKETING_USER/
# sudo -u www-data composer install
sudo composer install

read -e -p "Create Marketing user? [y/n] " -i "y" createmaketinguser
if [ "$createmaketinguser" = "y" ]; then
  read -s -p "Enter the Marketing Database password:" MARKETING_PASSWORD
  echo ""
  read -s -p "Re-Enter the Marketing Database password:" MARKETING_PASSWORD2
  while [ "$MARKETING_PASSWORD" != "$MARKETING_PASSWORD2" ]; do
    echo "Password does not match. Please try again"
    read -s -p "Enter the Marketing Database password:" MARKETING_PASSWORD
    echo ""
    read -s -p "Re-Enter the Marketing Database password:" MARKETING_PASSWORD2
  done
    echo "Creating Marketing Database and user."
    echo "You must supply the root user password for MariaDB:"
    mysql -u root -p << EOF
    GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
    # create $MARKETING_USER user
    DELETE FROM mysql.user WHERE User = '$MARKETING_USER';
    CREATE USER '$MARKETING_USER'@'localhost' IDENTIFIED BY '$MARKETING_PASSWORD';
    GRANT ALL PRIVILEGES ON *.* TO '$MARKETING_USER'@'localhost' WITH GRANT OPTION;
  FLUSH PRIVILEGES;
EOF
  echo
  echo
  
fi

read -e -p "Please enter the public host name for Marketing server (fully qualified domain name)${ques} [`hostname`] " -i "`hostname`" MARKETING_HOSTNAME
read -e -p "Please enter the protocol for Marketing server (fully qualified domain name)${ques} [http] " -i "http" MARKETING_PROTOCOL

if [ -n "$MARKETING_HOSTNAME" ]; then
  if [ "${MARKETING_PROTOCOL,,}" = "https" ]; then
    if [ -f "$BASE_INSTALL/scripts/ssl.sh" ]; then
      . $BASE_INSTALL/scripts/ssl.sh  $MARKETING_HOSTNAME
    else
      . scripts/ssl.sh $MARKETING_HOSTNAME
    fi
  else
     sudo rsync -avz $NGINX_CONF/sites-available/domain.conf /etc/nginx/sites-available/$MARKETING_HOSTNAME.conf
     sudo ln -s /etc/nginx/sites-available/$MARKETING_HOSTNAME.conf /etc/nginx/sites-enabled/
      
     sudo sed -i "s/@@DNS_DOMAIN@@/$MARKETING_HOSTNAME/g" /etc/nginx/sites-available/$MARKETING_HOSTNAME.conf
  fi
  sudo sed -i "s/##WEB_ROOT##/root \/var\/www\/$MARKETING_USER;/g" /etc/nginx/sites-available/$MARKETING_HOSTNAME.conf
  sudo sed -i "s/##INDEX##/index index.php index.html index.htm index.nginx-debian.html;/g" /etc/nginx/sites-available/$MARKETING_HOSTNAME.conf
   
  
  sudo mkdir temp
  sudo cp $NGINX_CONF/sites-available/$MARKETING_USER.snippet  temp/
  sudo sed -e '/##Marketing##/ {' -e 'r temp/mautic.snippet' -e 'd' -e '}' -i /etc/nginx/sites-available/$MARKETING_HOSTNAME.conf
  sudo rm -rf temp

fi

cd $WEBSERVER_PATH/$MARKETING_USER
sudo find . -type d -exec chmod 755 {} \;
sudo find . -type f -exec chmod 644 {} \;
sudo chmod -R g+w app/cache/ app/logs/ app/config/ media/files/ media/images/ translations/
sudo chown -R $USER:www-data .
sudo php app/console cache:clear --env=prod

sudo service nginx restart

echogreen "After you login into the home page, you will see profile avatar broken, the reason is Marketing will get avatar picture from http://www.gravatar.com via email"
echogreen " so you should use your email to register an account in http://www.gravatar.com "