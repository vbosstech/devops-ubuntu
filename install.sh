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

read -e -p "Please enter the public host name for your server (only domain name, not subdomain): " DOMAIN_NAME
sudo sed -i "s/MYCOMPANY.COM/$DOMAIN_NAME/g" $BASE_INSTALL/domain.txt

##################
# Run initializing script for ubuntu
##################
. $BASE_INSTALL/S1.os-upgrade.sh

##################
# 1. LEMP Stack
##################

# Run script to install LEMP
. $BASE_INSTALL/1.LEMP/S11.install-LEMP.sh

# Run script to install Mautic - Digital Marketing Automation
. $BASE_INSTALL/1.LEMP/S12.install-mautic.sh

# Run script to install Drupal
#. $BASE_INSTALL/1.LEMP/S13.install-drupal.sh

# Run script to install Magento2
#. $BASE_INSTALL/1.LEMP/S14.install-magento2.sh


##################
# 2. MEAN & Chatbot Environment
##################

# Run script to setup Nginx, NVM, PM2, Nodejs, Redis, MongoDB, CertbotSSL, SSL
. $BASE_INSTALL/S21.install-MEAN.sh


##################
# 3. JAVA & Tomcat: eWorkflow & eForms Environment
##################

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


##################
# 4. CLEANUP
##################


##################
# 5. Run script to install SSL: list of domain & port
##################
. $BASE_INSTALL/S2.ssl-domain-port.sh