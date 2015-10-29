#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y apache2 git php5 php5-curl mysql-client curl php5-mysql

cd ~/

git clone https://github.com/MickaelHubert974/itmo444-fall2015.git

sudo cp ~/itmo444-fall2015/MP1/applicationSetup/images /var/www/html/images
sudo cp ~/itmo444-fall2015/MP1/applicationSetup/*.html /var/www/html
sudo cp ~/itmo444-fall2015/MP1/applicationSetup/*.php /var/www/html

mapfile -t dbInstanceARR < <(aws rds describe-db-instances --output json | grep "\"DBInstanceIdentifier" | sed "s/[\"\:\, ]//g" | sed "s/DBInstanceIdentifier//g" )

if [ ${#dbInstanceARR[@]} -gt 0 ]
   then
   echo "Chekcing RDS database-instances"
   LENGTH=${#dbInstanceARR[@]}

      for (( i=0; i<${LENGTH}; i++));
      do
      if [ ${dbInstanceARR[i]} == "itmo444-db" ] 
     then 
      echo "db exists"
     else
     aws rds create-db-instance --db-instance-identifier itmo444-db --db-instance-class db.t1.micro --engine MySQL --master-username controller --master-user-password letmein42 --allocated-storage 5 --db-name customerrecords
     
      fi  
     done
fi

wait db-instance-available --db-instance-identifier itmo444-db

curl -sS https://getcomposer.org/installer | sudo php &> /tmp/getcomposer.txt

sudo php composer.phar require aws/aws-sdk-php &> /tmp/runcomposer.txt

sudo mv vendor /var/www/html &> /tmp/movevendor.txt

sudo php /var/www/html/setup.php &> /tmp/database-setup.txt

echo "Hello!" > /tmp/hello.txt
