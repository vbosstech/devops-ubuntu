#!/bin/bash
# ------------------------------------------
# This is script which defines constants
# ------------------------------------------

export APTVERBOSITY="-qq -y"
export DEFAULTYESNO="y"
export TIME_ZONE="Asia/Ho_Chi_Minh"
export LOCALESUPPORT=en_US.UTF-8
export LC_ALL="C"

export BASE_INSTALL=/home/ubuntu/devops-ubuntu
export TMP_INSTALL=/tmp/devops-ubuntu
export NGINX_CONF=$BASE_INSTALL/_ubuntu/etc/nginx
export GLOBAL_PROTOCOL=https

export COMPOSERURL=https://getcomposer.org/installer
export PHP_VERSION=7.1

export NVMURL=https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh
export NODEJSURL=https://deb.nodesource.com/setup_8.x
export NODEJS_LAMBDA=8.10.0

# export CAMUNDA_VERSION=7.8
# export TOMCAT8_VERSION=8.5.33
# export MAVEN_VERSION=3.5.4
# export ANT_VERSION=1.10.5
# export TOMCAT_HTTP_PORT=8888
# export TOMCAT_SHUTDOWN_PORT=8885
# export TOMCAT_AJP_PORT=8889
# export TOMCAT_HTTPS_PORT=8443
# export JAVA_VERSION=8u192
# export JAVA_VERSION_BUILD=b12
# export JAVA_DEST=jdk1.8.0_192
# export DEVOPS_HOME=/home/devops
# export CATALINA_HOME=$DEVOPS_HOME/tomcat
# export DEVOPS_USER=devops
# export DEVOPS_GROUP=$DEVOPS_USER
# export DEFAULTDB=P

# export PG_DB_PORT_DEFAULT=5432
# export PG_DB_DRIVER_DEFAULT=org.postgresql.Driver
# export PG_DB_CONNECTOR_DEFAULT=postgresql
# export PG_DB_SUFFIX_DEFAULT=''

# export DB_USERNAME_DEFAULT=camunda
# export DB_PASSWORD_DEFAULT=camunda
# export DB_NAME_DEFAULT=camunda
# export DB_PORT_DEFAULT=3306
# export DB_DRIVER_DEFAULT=com.mysql.jdbc.Driver
# export DB_CONNECTOR_DEFAULT=mysql
# export DB_SUFFIX_DEFAULT="\?useSSL=false\&amp;autoReconnect=true\&amp;useUnicode=yes\&amp;characterEncoding=utf8"
# export CAMUNDA_PROTOCOL_DEFAULT=http

# export MYSQL_DB_PORT_DEFAULT=3306
# export MYSQL_DB_DRIVER_DEFAULT=com.mysql.jdbc.Driver
# export MYSQL_DB_CONNECTOR_DEFAULT=mysql
# export MYSQL_DB_SUFFIX_DEFAULT="\?useSSL=false\&amp;autoReconnect=true\&amp;useUnicode=yes\&amp;characterEncoding=utf8"

# export ALF_DATA_HOME=$DEVOPS_HOME/alf_data
# export SOLR4_CONFIG_FILE=alfresco-solr4-5.2.g-config-ssl.zip

# export ALF_DB_USERNAME_DEFAULT=alfresco
# export ALF_DB_PASSWORD_DEFAULT=alfresco
# export ALF_DB_NAME_DEFAULT=alfresco
# export ALF_DB_PORT_DEFAULT=5432
# export ALF_DB_DRIVER_DEFAULT=org.postgresql.Driver
# export ALF_DB_CONNECTOR_DEFAULT=postgresql
# export ALF_DB_SUFFIX_DEFAULT=''
# export GHOSTSCRIPT_VERSION=9.23

# export MAGENTO_DB_DEFAULT="magento"
# export MAGENTO_USER_DEFAULT="magento"
# export MAGENTO_DB=$MAGENTO_DB_DEFAULT
# export MAGENTO_USER=$MAGENTO_USER_DEFAULT
# export MAGENTO_ADMIN_PASSWORD_DEFAULT="vboss.tech"

# export TOMCAT_DOWNLOAD=https://archive.apache.org/dist/tomcat/tomcat-8/v$TOMCAT8_VERSION/bin/apache-tomcat-$TOMCAT8_VERSION.tar.gz
# export JDBCPOSTGRESURL=https://jdbc.postgresql.org/download
# export JDBCPOSTGRES=postgresql-42.1.4.jar
# export JDBCMYSQLURL=http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.43
# export JDBCMYSQL=mysql-connector-java-5.1.43.jar

# export APACHEMAVEN=https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
# export APACHEANT=http://mirrors.viethosting.com/apache//ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
# export JAVA8URL=http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$JAVA_VERSION_BUILD/750e1c8617c5452694857ad95c3ee230/jdk-$JAVA_VERSION

# export ALFREPOWAR=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/alfresco-platform/5.2.g/alfresco-platform-5.2.g.war
# export ALFSHAREWAR=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/share/5.2.f/share-5.2.f.war
# export ALFSHARESERVICES=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/alfresco-share-services/5.2.f/alfresco-share-services-5.2.f.amp
# export ALFMMTJAR=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/alfresco-mmt/5.2.g/alfresco-mmt-5.2.g.jar

# export SOLR4_WAR_DOWNLOAD=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/alfresco-solr4/5.2.g/alfresco-solr4-5.2.g.war
# export LIBREOFFICE=http://downloadarchive.documentfoundation.org/libreoffice/old/5.1.6.2/deb/x86_64/LibreOffice_5.1.6.2_Linux_x86-64_deb.tar.gz
# export ALFRESCO_PDF_RENDERER=https://artifacts.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/alfresco-pdf-renderer/1.0/alfresco-pdf-renderer-1.0-linux.tgz
# export KEYSTOREBASE=https://svn.alfresco.com/repos/alfresco-open-mirror/alfresco/HEAD/root/projects/repository/config/alfresco/keystore

# export GHOSTSCRIPTURL=https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs923/ghostscript-9.23-linux-x86_64.tgz

# export GOOGLEDOCSREPO=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/integrations/alfresco-googledocs-repo/3.0.4.1/alfresco-googledocs-repo-3.0.4.1.amp
# export GOOGLEDOCSSHARE=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/integrations/alfresco-googledocs-share/3.0.4.1/alfresco-googledocs-share-3.0.4.1.amp

# export AOS_VTI=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/aos-module/alfresco-vti-bin/1.1.5/alfresco-vti-bin-1.1.5.war
# export AOS_SERVER_ROOT=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/alfresco-server-root/5.2.g/alfresco-server-root-5.2.g.war
# export AOS_AMP=https://artifacts.alfresco.com/nexus/content/repositories/public/org/alfresco/aos-module/alfresco-aos-module/1.1.6/alfresco-aos-module-1.1.6.amp
# export SOLR4_CONFIG=$BASE_INSTALL/_addons/solr4/$SOLR4_CONFIG_FILE

# export COMPOSERURL=https://getcomposer.org/installer

# export CAMUNDAURL=https://camunda.org/release/camunda-bpm/tomcat/$CAMUNDA_VERSION/camunda-bpm-tomcat-$CAMUNDA_VERSION.0.zip

# export NOTIFICATION_SERVICE_URL=https://pcca1bb0u2.execute-api.ap-northeast-1.amazonaws.com/production/notify/workchat
# export MYSQL_CONNECTOR_5146_URL=http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.46/mysql-connector-java-5.1.46.jar
# export NOTIFICATION_SERVICE_DEV_URL=https://2ecg1x131e.execute-api.us-east-1.amazonaws.com/devV1/notify/workchat

## REDHAT ##
# export REDHAT_USER=vbosstech@gmail.com
# export REDHAT_PASSWORD=vboss.tech