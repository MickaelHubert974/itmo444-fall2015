#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apache2 git php5 php5-curl mysql-client curl php5-mysql php5-imagick

cd ~/

git clone https://github.com/MickaelHubert974/itmo444-fall2015.git

sudo cp ~/itmo444-fall2015/MP-Final/applicationSetup/images/* /var/www/html/images
sudo cp ~/itmo444-fall2015/MP-Final/applicationSetup/* /var/www/html
sudo cp ~/itmo444-fall2015/MP-Final/applicationSetup/css/* /var/www/html/css


curl -sS https://getcomposer.org/installer | sudo php &> /tmp/getcomposer.txt

sudo php composer.phar require aws/aws-sdk-php &> /tmp/runcomposer.txt

sudo mv vendor /var/www/html &> /tmp/movevendor.txt

sudo php /var/www/html/setup.php &> /tmp/database-setup.txt

sudo chmod 600 /var/www/html/setup.php

echo "Hello!" > /tmp/hello.txt
