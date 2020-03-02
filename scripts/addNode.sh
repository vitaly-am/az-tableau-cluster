#!/bin/bash -x

tsm_admin_user = $1
tsm_admin_pass = $2
primary_dns = $3
INSTALL_SCRIPT_URL = $4

cd /tmp
expect -c \"spawn sftp -o \\\"StrictHostKeyChecking no\\\" \\\"$tsm_admin_user@$primary_dns\\\";expect \\\"password:\\\";send \\\"$tsm_admin_pass\\n\\\";expect \\\"sftp>\\\";send \\\"get bootstrap.cfg\\n\\\";expect \\\"sftp>\\\";send \\\"exit\\n\\\";interact\"

# download distr
wget --tries=3 --output-document=tableau-installer.rpm https://downloads.tableau.com/esdalt/2019.4.0/tableau-server-2019-4-0.x86_64.rpm

# download automated-installer
wget --remote-encoding=UTF-8 --output-document=automated-installer.sh $INSTALL_SCRIPT_URL
chmod +x automated-installer.sh
#installation
sudo ./automated-installer.sh -a $tsm_admin_user -f /dev/zero -r /dev/zero -s /tmp/secrets.properties -b bootstrap.cfg -v --accepteula --force /tmp/tableau-installer.rpm
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
