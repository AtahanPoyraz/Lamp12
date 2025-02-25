#!/bin/sh
###########################################
# Bash script to install an AMP stack     #
# Developed by Atahan & Bilgehan Poyraz   #
###########################################

# Special Color
Color_Off="\033[0m"		# Text Reset
IColor="\033[40;38;5;82m"	# info Color
Blink="\033[5m"			# Blink Text for MariaDB

#Give you here needful Vaules
fqdn="fdwh01.formdata.com.tr"	# FQDN name
hname="fdwh01"			# Hostname
Dba="dbadmin"			# MariaDB database Admin
DBName1="EspoCRMDB"		# Database name
DBName2="NextDB"		# Database name
DBapass="eniezvll43319Z86"	# MariaDB dbadmin Password
DBSecPass="f51865198RMIDZQM"	# Secure Installation

# Regular Colors
Red="\033[0;31m"	# Red
Green="\033[0;32m"	# Greennan
Yellow="\033[0;33m"	# Yellow
Blue="\033[0;34m"	# Blue
Purple="\033[0;35m"	# Purple
Cyan="\033[0;36m"	# Cyan

## Modifying hostname and hosts File content
clear
echo "$Blink \n Did you edit the parameters section? $Color_Off" && sleep 10
echo "$Blue \n Changing your hostname and hosts file content $Color_Off" && sleep 3
mv /etc/hosts /etc/hosts.org
echo "127.0.0.1	localhost">> /etc/hosts
echo "127.0.1.1	$fqdn	$hname">> /etc/hosts
echo "">> /etc/hosts
echo "# The following lines are desirable for IPv6 capable hosts">> /etc/hosts
echo "::1	localhost ip6-localhost ip6-loopback">> /etc/hosts
echo "ff02::1	ip6-allnodes">> /etc/hosts
echo "ff02::2	ip6-allrouters">> /etc/hosts
mv /etc/hostname /etc/hostname.org
echo "$hname">> /etc/hostname

## Set Timezone & Keyboard Layout
clear
echo "$Purple \n Setting Time Zone and Keyboard Layout $Color_Off" && sleep 3
timedatectl set-timezone Europe/Istanbul
localectl set-keymap tr
localectl set-x11-keymap tr
echo "$IColor \n Time zone and Keyboard Layout has been set to Turkish $Color_Off" && sleep 3
clear

## Modifying Sources.list File
clear
echo "$Red \n Modifying Sources.list File $Color_Off" && sleep 3
mv /etc/apt/sources.list /etc/apt/sources.list.org

echo "#------------------------------------------------------------------------------#">> /etc/apt/sources.list
echo "#                   OFFICIAL DEBIAN 12 REPOS                                   #">> /etc/apt/sources.list
echo "#------------------------------------------------------------------------------#">> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm main non-free-firmware">> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bookworm main non-free-firmware">> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware">> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian-security/ bookworm-security main non-free-firmware">> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bookworm-updates main non-free-firmware">> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware">> /etc/apt/sources.list
echo "$IColor \n Sources.list file content has been changed $Color_Off" && sleep 3
clear

## Update packages and Upgrade system
echo "$Green \n Updating System.. $Color_Off" && sleep 3
clear
apt -y update && apt -y upgrade
echo "$IColor \n Debian has been updated $Color_Off" && sleep 3
clear

## Install pre-request packages
echo "$Yellow \n Installing pre-request packages $Color_Off" && sleep 3
clear
apt -y install nano zip unzip wget dirmngr libmcrypt-dev make --install-recommends
echo "$IColor \n Pre-Request packages has been installed $Color_Off" && sleep 3
clear

## Install VMtools
echo "$Blue \n Checking VMtools $Color_Off" && sleep 3
clear
apt -y install open-vm-tools --install-recommends
echo "$IColor \n VMtools installation checked $Color_Off" && sleep 3
clear

## Install Apache 
echo "$Cyan \n Installing Apache2 $Color_Off" && sleep 3
clear
apt -y install apache2 apache2-utils apache2-dev openssl --install-recommends
systemctl enable apache2
# Enabling Mod Rewrite and required Modules
clear
echo "$Red \n Enabling Modules $Color_Off" && sleep 3
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime
a2enmod setenvif
a2enmod unique_id
# If you need Reverse Proxy (Nextcloud or OwnCloud)
#a2enmod proxy
#a2enmod proxy_http
#a2enmod proxy_connect
#a2enmod proxy_wstunnel
echo "$IColor \n Apache web server and options has been installed $Color_Off" && sleep 3
clear

## Install MariaDB
echo "$Green \n Installing MariaDB $Color_Off" && sleep 3
apt -y install mariadb-server mariadb-client mariadb-backup --install-recommends
systemctl enable mariadb
clear

##Creating User and Give Permission
#Creating User
echo "$Yellow \n Creating MariaDB user $Color_Off"
mariadb -uroot -px -e "CREATE USER '$Dba'@'localhost' IDENTIFIED BY '$DBapass'; GRANT ALL PRIVILEGES ON *.* TO '$Dba'@'localhost' WITH GRANT OPTION;"
#Creating DB
echo "$Green \n creating MariaDB Database $Color_Off"
mariadb -uroot -px -e "CREATE DATABASE $DBName1; GRANT ALL ON $DBName1.* TO '$Dba'@'localhost' IDENTIFIED BY '$DBapass' WITH GRANT OPTION;"
mariadb -uroot -px -e "CREATE DATABASE $DBName2; GRANT ALL ON $DBName2.* TO '$Dba'@'localhost' IDENTIFIED BY '$DBapass' WITH GRANT OPTION;"
echo "$IColor \n MariaDB has been installed, User and Database Created $Color_Off" && sleep 3
#Secure MariaDB installation
clear
echo "$Blink \n Let's run MariaDB Secure Installation Script $Color_Off" && sleep 3
mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('$DBSecPass');FLUSH PRIVILEGES;"
mysql -e "DELETE FROM mysql.user WHERE User='';"
mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
#mysql -e "DROP DATABASE test; DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';"

## Install PHP and modules
echo "$Blue \n Installing PHP and Modules $Color_Off" && sleep 3
clear
apt -y install php php-dev php-cli php-common php-json php-readline libmcrypt-dev libapache2-mod-php php-mysql php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip php-ldap php-apcu php-imagick php-imap php-bcmath php-gmp php-cgi php-memcached php-net-smtp php-phpseclib php-php-gettext php-bz2 php-fpm php-net-socket php-xml-util php-dompdf --install-recommends
echo "<?php phpinfo(); ?>" >> /var/www/html/info.php
echo "$IColor \n PHP and modules has been installed $Color_Off" && sleep 3
clear

## Change some PHP parameters
echo "$Cyan \n Changing some PHP parameters $Color_Off" && sleep 3
clear
# /etc/php/8.2/apache2/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 360/g" /etc/php/8.2/apache2/php.ini
sed -i "s/max_input_time = 60/max_input_time = 360/g" /etc/php/8.2/apache2/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /etc/php/8.2/apache2/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 512M/g" /etc/php/8.2/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 512M/g" /etc/php/8.2/apache2/php.ini
sed -i "s/; output_buffering = 4096/output_buffering = 4096/g" /etc/php/8.2/cli/php.ini
# /etc/php/8.2/cli/php.ini
sed -i "s/max_execution_time = 30/max_execution_time = 360/g" /etc/php/8.2/cli/php.ini
sed -i "s/max_input_time = 60/max_input_time = 360/g" /etc/php/8.2/cli/php.ini
sed -i "s/memory_limit = 128M/memory_limit = 1024M/g" /etc/php/8.2/cli/php.ini
sed -i "s/post_max_size = 8M/post_max_size = 512M/g" /etc/php/8.2/cli/php.ini
sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 512M/g" /etc/php/8.2/cli/php.ini
sed -i "s/; output_buffering = 4096/output_buffering = 4096/g" /etc/php/8.2/cli/php.ini
clear

## Install Memcached
echo "$Red \n Installing and configuring Memcached $Color_Off" && sleep 3
clear
apt -y install memcached libmemcached-tools --install-recommends
systemctl enable memcached
phpenmod memcached
echo "$IColor \n Memcached installed and enabled $Color_Off" && sleep 3
clear

## Restart Apache
echo "$Blue \n Restarting Apache $Color_Off" && sleep 3
clear
systemctl restart apache2
clear
echo "$IColor \n LAMP server has been installed and set $Color_Off"
echo "$Blink \n Please reboot the system $Color_Off"
