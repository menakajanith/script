
#!/bin/bash

# Update system
echo "Updating system..."
sudo apt update -y

# Install Apache2
echo "Installing Apache2..."
sudo apt install apache2 -y

# Enable firewall and allow Apache traffic
echo "Setting up firewall..."
sudo ufw enable
sudo ufw allow 'Apache Full'
sudo ufw allow ssh

# Enable firewalld
echo "Enabling firewalld..."
sudo systemctl enable firewalld

# Clone the script repository
echo "Cloning the GitHub repository..."
git clone https://github.com/menakajanith/script.git /var/www/script

# Set up Apache VirtualHost configuration
echo "Configuring Apache..."
sudo bash -c 'cat > /etc/apache2/sites-available/menakajanith.cloud.conf <<EOF
<VirtualHost *:80>
    ServerName www.menakajanith.cloud
    ServerAdmin contact@menakajanith.cloud
    DocumentRoot /var/www/script
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF'

# Enable the site and disable the default site
echo "Enabling the site and disabling default..."
sudo a2ensite menakajanith.cloud.conf
sudo a2dissite 000-default.conf

# Restart Apache service
echo "Restarting Apache..."
sudo service apache2 restart

# Install Certbot for SSL
echo "Installing Certbot..."
sudo apt install certbot python3-certbot-apache -y

# Obtain SSL certificate
echo "Setting up SSL..."
sudo certbot --apache

echo "Setup complete!"
