#!/bin/bash

echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

echo "Installing necessary dependencies..."
sudo apt install -y apache2 socat iptables

echo "Configuring Apache to listen on port 10000..."
sudo sed -i 's/Listen 80/Listen 10000/' /etc/apache2/ports.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:10000>/' /etc/apache2/sites-available/000-default.conf

echo "Restarting Apache to apply changes..."
sudo systemctl restart apache2

echo "Configuring iptables..."
sudo iptables -A INPUT -p tcp --dport 10000 -j DROP
sudo iptables -A INPUT -i lo -p tcp --dport 10000 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

echo "Copying index.html and error.html to /var/www/html..."
sudo cp ./index.html /var/www/html/index.html
sudo cp ./error.html /var/www/html/error.html

echo "Copying proxyServer.sh to /etc..."
sudo cp ./proxyServer.sh /etc/proxyServer.sh

echo "Setting execute permissions for proxyServer.sh..."
sudo chmod +x /etc/proxyServer.sh

echo "Copying proxyServer.service to /etc/systemd/system/..."
sudo cp ./proxyServer.service /etc/systemd/system/proxyServer.service

echo "Reloading systemd to register the new service..."
sudo systemctl daemon-reload

echo "Enabling and starting proxyServer service..."
sudo systemctl enable proxyServer.service
sudo systemctl start proxyServer.service

echo "Checking the status of proxyServer service..."
sudo systemctl status proxyServer.service

echo "Setup complete!"

