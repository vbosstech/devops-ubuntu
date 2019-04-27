#!/bin/bash
# -------
# Script to setup, install and configure all-in-one devops environment
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

echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "[install.sh] OS upgrade, Utilities, Nginx, Certbot"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Would you like to run S1.os-upgrade.sh? ${ques} [y/n] " -i "$DEFAULTYESNO" osupgrade
if [ "$osupgrade" = "y" ]; then
     . $BASE_INSTALL/S1.os-upgrade.sh
fi

######################################################
# 1. LEMP Stack
######################################################

# Run script to install LEMP
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "[Install LEMP] PHP & MySQL/MariaDB"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Would you like to run S11.install-LEMP? ${ques} [y/n] " -i "$DEFAULTYESNO" installlemp
if [ "$installlemp" = "y" ]; then
# . $BASE_INSTALL/1.LEMP/S11.install-LEMP.sh

# Run script to install Mautic - Digital Marketing Automation
echo
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
echo "[Install LEMP] Mautic: open-source Digital Marketing Automation"
echoblue "- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
read -e -p "Would you like to run S1.os-upgrade.sh? ${ques} [y/n] " -i "$DEFAULTYESNO" installmautic
if [ "$installmautic" = "y" ]; then
     . $BASE_INSTALL/1.LEMP/S12.install-mautic.sh
fi

# Run script to install Drupal
#. $BASE_INSTALL/1.LEMP/S13.install-drupal.sh

# Run script to install Magento2
#. $BASE_INSTALL/1.LEMP/S14.install-magento2.sh


######################################################
# 2. MEAN & Chatbot Environment
######################################################

# Run script to setup Nginx, NVM, PM2, Nodejs, Redis, MongoDB, CertbotSSL, SSL
# . $BASE_INSTALL/S21.install-MEAN.sh


######################################################
# 3. JAVA & Tomcat: eWorkflow & eForms Environment
######################################################

# Run script to setup Maven, Ant, Java, Tomcat, Database, Jenkins
# . $BASE_INSTALL/S2.install-TOMCAT.sh

# Run script to setup Alfresco
# TODO for temporary, we need to install Alfresco before Camunda because they use the same server.xml (tomcat)
# but we will find a way to insert alfresco configuration into server.xml instead of overwriting the existing server.xml

# . $BASE_INSTALL/S21.install-alfresco.sh
## Run script to setup Camunda

##. $BASE_INSTALL/S22.install-camunda.sh

# Run script to setup Eforms
##. $BASE_INSTALL/S2.3.install-eforms.sh

# Run script to setup Cashflow
##. $BASE_INSTALL/S2.4.install-cashflow.sh


######################################################
# 4. CLEANUP
######################################################


######################################################
# 5. Run script to install SSL: list of domain & port
######################################################
# . $BASE_INSTALL/S2.ssl-domain-port.sh

# read -e -p "Please enter the public host name for your server (only domain name, not subdomain): " DOMAIN_NAME
# sudo sed -i "s/MYCOMPANY.COM/$DOMAIN_NAME/g" $BASE_INSTALL/domain.txt