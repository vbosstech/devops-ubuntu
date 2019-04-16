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

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echogreen "Begin running...."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo

# @FIXME using AWS RDS instead of
if [ "$(which mysql)" = "" ]; then
  . $BASE_INSTALL/scripts/mariadb.sh
fi
  
# Install PHP
if [ "$(which php)" = "" ]; then
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  echo "Installing PHP for system."
  echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
  sudo add-apt-repository ppa:ondrej/nginx-mainline
  sudo apt-get update

  sudo apt-get $APTVERBOSITY install php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-common php$PHP_VERSION-json php$PHP_VERSION-opcache \
       php$PHP_VERSION-mysql php$PHP_VERSION-mbstring php$PHP_VERSION-mcrypt php$PHP_VERSION-zip php$PHP_VERSION-fpm php$PHP_VERSION-bcmath \
       php$PHP_VERSION-intl php$PHP_VERSION-simplexml php$PHP_VERSION-dom php$PHP_VERSION-curl php$PHP_VERSION-gd php$PHP_VERSION-imap php$PHP_VERSION-xsl
  
  echoblue "PHP installation has been completed"
fi

echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "Composer is an PHP dependency management tool...."
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# Install composer
if [ "$(which composer)" = "" ]; then
  if [ ! -d "$TMP_INSTALL" ]; then
    mkdir $TMP_INSTALL
  fi  
  echo "Downloading Composer to temporary folder..."
  curl -# -o $TMP_INSTALL/composer $COMPOSERURL
  sudo php $TMP_INSTALL/composer

  # Install composer globally
  if [ -f "composer.phar" ]; then
    sudo mv composer.phar /usr/local/bin/composer
    sudo mkdir ~/.composer
    sudo chmod -R 775 ~/.composer
    sudo chown -R www-data:www-data ~/.composer
  else
    echo "Cannot find composer.phar, we check and try again."
    exit 1
  fi
  echoblue "Composer has been installed successfully"
fi

# Add php config
if [ -f "/etc/php/$PHP_VERSION/fpm/php.ini" ]; then
  sudo sed -i "s/\(^memory_limit =\).*/\1 1024M/"             /etc/php/$PHP_VERSION/fpm/php.ini
  sudo sed -i "s/\(^max_execution_time =\).*/\1 1200/"        /etc/php/$PHP_VERSION/fpm/php.ini
  sudo sed -i "s/\(^zlib.output_compression =\).*/\1 On/"     /etc/php/$PHP_VERSION/fpm/php.ini
  sudo sed -i "s/\(^zmax_input_time =\).*/\1 300/"            /etc/php/$PHP_VERSION/fpm/php.ini
  sudo sed -i "s/\(^zpost_max_size =\).*/\1 512M/"            /etc/php/$PHP_VERSION/fpm/php.ini
  sudo sed -i "s/\(^zupload_max_filesize =\).*/\1 256M/"      /etc/php/$PHP_VERSION/fpm/php.ini
  sudo sed -i "s/\(^zmax_file_uploads =\).*/\1 60/"           /etc/php/$PHP_VERSION/fpm/php.ini
  echo 'date.timezone = Asia/Ho_Chi_Minh' | sudo tee --append /etc/php/$PHP_VERSION/fpm/php.ini

  sudo systemctl restart php$PHP_VERSION-fpm
else
  echo "There is no file php.ini, please check if php is installed correctly."
fi