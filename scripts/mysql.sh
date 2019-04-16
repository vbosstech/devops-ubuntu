#!/bin/bash
# -------
# Script for installation of mysql
#
# -------

export DB_NAME=marketing
export DB_USER=marketing

echo
echo "--------------------------------------------"
echo "This script will install MYSQL-DB."
echo "and create Workforce database and user."
echo "You may first be prompted for sudo password."
echo "When prompted during MYSQL-DB Install,"
echo "type the default root password for MYSQL-DB."
echo "--------------------------------------------"
echo

read -e -p "Install MYSQL-DB? [y/n] " -i "n" installmysqldb
if [ "$installmysqldb" = "y" ]; then
  sudo apt-get install mysql-server
fi

read -e -p "Create Alfresco Database and user? [y/n] " -i "y" createdbalfresco
if [ "$createdbalfresco" = "y" ]; then
  read -s -p "Enter the Alfresco database password:" DB_PASSWORD
  echo ""
  read -s -p "Re-Enter the Alfresco database password:" DB_PASSWORD2
  if [ "$DB_PASSWORD" == "$DB_PASSWORD2" ]; then
    echo "Creating Alfresco database and user."
    echo "You must supply the root user password for mysql:"
    mysql -u root -p << EOF
create database $DB_NAME default character set utf8 collate utf8_bin;
grant all on $DB_NAME.* to '$DB_USER'@'localhost' identified by '$DB_PASSWORD' with grant option;
grant all on $DB_NAME.* to '$DB_USER'@'localhost.localdomain' identified by '$DB_PASSWORD' with grant option;

EOF
    echo
    echo "Passwords do not match. Please run the script again for better luck!"
    echo
fi