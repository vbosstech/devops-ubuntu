#!/bin/bash
# -------
# Script for install of Mariadb
# -------

echo
echo "--------------------------------------------"
echo "This script will install MariaDB."
echo "and create Devops database and user."
echo "You may first be prompted for sudo password."
echo "When prompted during MariaDB Install,"
echo "type the default root password for MariaDB."
echo "--------------------------------------------"
echo

read -e -p "Install MariaDB? [y/n] " -i "y" installmariadb
if [ "$installmariadb" = "y" ]; then
  sudo apt-get remove --purge *mysql\*
  sudo apt-get autoremove
  sudo apt-get autoclean
  sudo deluser mysql
  sudo rm -rf /var/lib/mysql
  sudo rm -rf /var/log/mysql
  sudo rm -rf /etc/mysql
  sudo apt-get install software-properties-common
  sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
  sudo add-apt-repository "deb [arch=amd64,i386,ppc64el] http://ftp.ddg.lth.se/mariadb/repo/10.1/ubuntu $(lsb_release -cs) main"
  sudo apt-get update
  sudo apt-get install -y mariadb-server
  sudo mysql_secure_installation
  #Tuning database by setting config
  echo "[myisamchk]" | sudo tee -a /etc/mysql/conf.d/mariadb.cnf
  echo "key_buffer_size      = 128M" | sudo tee -a /etc/mysql/conf.d/mariadb.cnf
  
  echo "[mysqld]" | sudo tee -a /etc/mysql/conf.d/mariadb.cnf
  echo "max_allowed_packet   = 128M" | sudo tee -a /etc/mysql/conf.d/mariadb.cnf
  echo "thread_stack         = 1024K"| sudo tee -a /etc/mysql/conf.d/mariadb.cnf
  echo "thread_cache_size    = 64"| sudo tee -a /etc/mysql/conf.d/mariadb.cnf
  echo "innodb_log_file_size = 128M" | sudo tee -a /etc/mysql/conf.d/mariadb.cnf
  
  sudo systemctl start mariadb 
  sudo systemctl enable mariadb
fi