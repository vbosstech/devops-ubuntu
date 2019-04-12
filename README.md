# DevOps on Ubuntu 16.04 LTS

Please visit http://devops.oceansoft.io/2.Managed-Cloud-Services-for-DevOps/DevOps-on-Ubuntu-1604/ for more detail.

## 1. Prerequisites
    
- [x] [1.1. AWS Free Tier](1.Prerequisites/1.1.AWS.FreeTrial/)
- [x] [1.2. GCP Free Tier](1.Prerequisites/1.2.GCP.FreeTrial/)
- Git clone
  ```
    git clone https://github.com/vbosstech/devops-ubuntu.git
    cd devops-ubuntu

    ./1.os-upgrade.sh 
  ```

## 2. Installing scripts

| # | Function Name               | Description                                                                                 |
| - |:--------------------------- | :------------------------------------------------------------------------------------------ |
| [x] | 1.os-upgrade.sh           | curl, wget, rsync, zip, unzip, git,  awscli; and SwapFile, en_US.utf8, TimeZone             |
| [ ] | 2.install-MEAN.sh         | nginx, nvm, nodejs, pm2, redis, mongo, jenkins, certbot, python, pip, mkdocs, jekyll, gasby |
| [ ] | 2.2.install-eforms.sh     | eForm-Builder & eForm-Renderer in Angular & React                                           |
| [ ] | 3.install-JAVA-TOMCAT.sh  | Maven, Ant, Java, Tomcat, Database                                                          |
| [ ] | 3.1.install-alfresco.sh   | Alfresco                                                                                    |
| [ ] | 3.2.install-camunda.sh    | Camunda                                                                                     |
| [x] | 4.install-LEMP.sh         | Linux, Nginx, MySQL, PHP (LEMP stack)                                                       |
| [x] | 4.1.install-mautic.sh     | Mautic - Digital Marketing Automation                                                       |
| [ ] | 4.2.install-magento2.sh   | Magento2                                                                                    |
