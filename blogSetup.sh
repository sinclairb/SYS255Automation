echo "Restarting NIC"
systemctl restart network

echo "Creating User and making it admin"
useradd ben
echo -e "Hamburger69\nHamburger69" | passwd ben
usermod -aG wheel ben

echo "Installing Packages for Joining Windows Domain"
yum -y install realmd samba samba-common oddjob oddjob-mkhomedir sssd

echo "Joining Windows Domain"
echo -e "Hamburger69" | realm join --user=ben.sinclair@ben.local ben.local

echo "Copying SSHD Config File"
cp /sshd_config /etc/ssh/sshd_config

echo "Installing HTTP" 
yum -y install httpd

echo "Starting HTTP" 
systemctl enable httpd
systemctl start httpd

echo "Installing Maria DB"
yum -y install mariadb-server mariadb

echo "Starting MariaDB"
systemctl enable mariadb
systemctl start mariadb

echo "Securing MariaDB"
mysql_secure_installation << EOF

y
Hamburger69
Hamburger69
y
y
y
y
EOF

echo "Installing PHP"
yum -y install php php-mysql

echo "Restarting HTTP to load new configs"
systemctl restart httpd

echo "Setting Firewall Rules"
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

echo "Reloading Firewall"
firewall-cmd --reload

echo "Logging into MySQL"
mysql -u root -pHamburger69 -e "CREATE DATABASE wordpress; CREATE USER ben@localhost IDENTIFIED BY 'Hamburger69'; GRANT ALL PRIVILEGES ON wordpress.* TO ben@localhost IDENTIFIED BY 'Hamburger69'; FLUSH PRIVILEGES; exit"

echo "Obtaining WordPress"
yum -y install php-gd
systemctl restart httpd
cd ~
wget http://wordpress.org/latest.tar.gz

echo "Unzipping Wordpress Install"
tar xzvf latest.tar.gz

echo "Moving Files"
rsync -avP ~/wordpress/ /var/www/html/

echo "Making uploads directory"
mkdir /var/www/html/wp-content/uploads

echo "Changing File Perms"
chown -R apache:apache /var/www/html/*

echo "Making config file"
cd /var/www/html
cp /wp-config.php /var/www/html/wp-config.php
