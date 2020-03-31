#!/bin/bash

tsm_admin_user=$1
tsm_admin_pass=$2
primary_dns=$3
INSTALL_SCRIPT_URL=$4

sudo yum -y install sshpass

cd /tmp

yes | sshpass -p "${tsm_admin_pass}" scp -v -o StrictHostKeyChecking=no $tsm_admin_user@$primary_dns:./bootstrap.cfg /tmp/
yes | sshpass -p "${tsm_admin_pass}" scp -v -o StrictHostKeyChecking=no $tsm_admin_user@$primary_dns:./secrets /tmp/secrets

# download distr
wget --tries=3 --output-document=tableau-installer.rpm https://downloads.tableau.com/esdalt/2020.1.0/tableau-server-2020-1-0.x86_64.rpm

# download automated-installer
wget --remote-encoding=UTF-8 --output-document=automated-installer.sh $INSTALL_SCRIPT_URL
chmod +x automated-installer.sh
#installation
sudo ./automated-installer.sh -a $tsm_admin_user -f /dev/zero -r /dev/zero -b bootstrap.cfg -s secrets -v --accepteula --force /tmp/tableau-installer.rpm
