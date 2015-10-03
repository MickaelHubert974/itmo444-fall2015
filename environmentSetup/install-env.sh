#!/bin/bash

sudo apt-get update -y

sudo apt-get install -y apache2 git

git clone https://github.com/MickaelHubert974/itmo444-fall2015.git

sudo cp ~/itmo444-fall2015/applicationSetup/*.html /var/www/html

echo hello >/tmp/hello.txt



