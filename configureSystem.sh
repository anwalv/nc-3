#!/bin/bash

# Оновлення пакетів
echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y

# Встановлення необхідних залежностей
echo "Installing necessary dependencies..."
sudo apt install -y apache2 socat iptables

# Налаштування Apache на порт 10000
echo "Configuring Apache to listen on port 10000..."
# Зміна порту Apache з 80 на 10000
sudo sed -i 's/Listen 80/Listen 10000/' /etc/apache2/ports.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:10000>/' /etc/apache2/sites-available/000-default.conf

# Перезапуск Apache, щоб застосувати зміни
echo "Restarting Apache to apply changes..."
sudo systemctl restart apache2

# Налаштування iptables для обмеження доступу до порту 10000
echo "Configuring iptables..."
sudo iptables -A INPUT -p tcp --dport 10000 -j DROP  # Забороняємо доступ до порту 10000 ззовні
sudo iptables -A INPUT -i lo -p tcp --dport 10000 -j ACCEPT  # Дозволяємо доступ до порту 10000 локально
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT  # Дозволяємо доступ до порту 80 (для проксі)

# Копіювання HTML файлів до директорії Apache
echo "Copying index.html and error.html to /var/www/html..."
sudo cp ./index.html /var/www/html/index.html
sudo cp ./error.html /var/www/html/error.html

# Копіювання скрипту proxyServer.sh до /etc/
echo "Copying proxyServer.sh to /etc..."
sudo cp ./proxyServer.sh /etc/proxyServer.sh

# Надання прав на виконання для скрипту proxyServer.sh
echo "Setting execute permissions for proxyServer.sh..."
sudo chmod +x /etc/proxyServer.sh

# Копіювання файлу системного сервісу proxyServer.service
echo "Copying proxyServer.service to /etc/systemd/system/..."
sudo cp ./proxyServer.service /etc/systemd/system/proxyServer.service

# Перезавантаження systemd для того, щоб він зареєстрував новий сервіс
echo "Reloading systemd to register the new service..."
sudo systemctl daemon-reload

# Включення і запуск сервісу proxyServer
echo "Enabling and starting proxyServer service..."
sudo systemctl enable proxyServer.service
sudo systemctl start proxyServer.service

# Перевірка статусу сервісу
echo "Checking the status of proxyServer service..."
sudo systemctl status proxyServer.service

echo "Setup complete!"

