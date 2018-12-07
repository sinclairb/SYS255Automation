# User configures parameters needed for setup
read -p "Enter new username: " user
read -p "Enter new password: " pass

read -p "Enter domain name, eg ben.local: " domain
read -p "Enter domain username: " domainuser
read -p "Enter domain password: " domainpass

read -p "Enter location of sshd_config: " loc

# Assumes the network has been configured
echo "Restarting network"
systemctl restart network


# CONFIGURABLE
# Creates account, sets password, and adds to wheel
echo "Creating admin account"
useradd $user
# Must enter password twice
echo -e "$pass\n$pass" | passwd $user
usermod -aG wheel $user


# CONFIGURABLE
echo "Installing domain dependencies"
yum -y install realmd samba samba-common oddjob oddjob-mkhomedir sssd

echo "Joining domain $domain"
echo -e "$domainpass" | realm join --user=${domainuser}@${domain} ${domain}

# CONFIGURABLE
echo "Removing remote root login"
cp $loc /etc/ssh/sshd_config

echo "Installing httpd service" 
yum -y install httpd

echo "Starting httpd service" 
systemctl enable httpd
systemctl start httpd

echo "Installing MariaDB"
yum -y install mariadb-server mariadb

echo "Starting MariaDB"
systemctl enable mariadb
systemctl start mariadb

echo "Configuring MariaDB"
mysql_secure_installation << EOF

y
$pass
$pass
y
y
y
y
EOF

echo "Installing PHP"
yum -y install php php-mysql

echo "Restarting httpd"
systemctl restart httpd

echo "Setting firewall rules"
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

echo "Reloading firewall"
firewall-cmd --reload


echo "DONE!"
