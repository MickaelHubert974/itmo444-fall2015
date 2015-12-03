#!/bin/bash

asd() {
cat <<"EOT"

 __      __       .__                               
/  \    /  \ ____ |  |   ____  ____   _____   ____  
\   \/\/   // __ \|  | _/ ___\/  _ \ /     \_/ __ \ 
 \        /\  ___/|  |_\  \__(  <_> )  Y Y  \  ___/     
  \__/\  /  \___  >____/\___  >____/|__|_|  /\___  >
       \/       \/          \/            \/     \/
       
       
EOT
}

asd

declare -a instancesID

mapfile -t instancesID < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --security-group-ids $4 --subnet-id $5 --associate-public-ip-address --key-name $6 --user-data file://../environmentSetup/install-webserver.sh --iam-instance-profile Name=$7 --output table | grep InstanceId | sed "s/|//g" | sed "s/ //g" | sed "s/InstanceId//g")

echo "Launching the following instances : "
echo ${instancesID[@]}

aws ec2 wait instance-running --instance-ids ${instancesID[@]}

echo "Creating load balancer named itmo444-lb"

lburl=(`aws elb create-load-balancer --load-balancer-name itmo444-lb --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $5 --security-groups $4`)

echo $lburl

declare -a IDARRAY
IDARRAY=(`aws ec2 describe-instances --output table | grep InstanceId | sed "s/|//g" | sed "s/ //g" | sed "s/InstanceId//g"`)

echo "Registering instances with load balancer"
aws elb register-instances-with-load-balancer --load-balancer-name itmo444-lb --instances ${IDARRAY[@]}

echo "Health check configuring"
aws elb configure-health-check --load-balancer-name itmo444-lb --health-check Target=HTTP:80/,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3

echo "Add cookie stickiness policy"
aws elb create-lb-cookie-stickiness-policy --load-balancer-name itmo444-lb --policy-name my-duration-cookie-policy --cookie-expiration-period 500
aws elb set-load-balancer-policies-of-listener --load-balancer-name itmo444-lb --load-balancer-port 80 --policy-names my-duration-cookie-policy
aws elb describe-load-balancers --load-balancer-name itmo444-lb

#database

echo "Creating database and read replica"

aws rds create-db-instance --db-instance-identifier itmo444-db --db-instance-class db.t1.micro --engine MySQL --master-username controller --master-user-password letmein42 --allocated-storage 5 --db-name customerrecords

hawk() {
cat <<"EOT"

                                  .  .  .  .
                                  .  |  |  .
                               .  |        |  .
                               .              .
 ___     ___    _________    . |  (\.|\/|./)  | .   ___   ____
|   |   |   |  /    _    \   .   (\ |||||| /)   .  |   | /   /
|   |___|   | |    /_\    |  |  (\  |/  \|  /)  |  |   |/   /
|           | |           |    (\            /)    |       /
|    ___    | |    ___    |   (\              /)   |       \
|   |   |   | |   |   |   |    \      \/      /    |   |\   \
|___|   |___| |___|   |___|     \____/\/\____/     |___| \___\
                                    |0\/0|
                                     \/\/
                                      \/

EOT
}

hawk

cow(){
cat <<"EOT"
                   ________________________________
          (__)    /                                \         
          (oo)   ( Please wait...might take a while )
   /-------\/  --'\________________________________/        
  / |     ||
 *  ||----||             
    ^^    ^^
EOT
}
cow


aws rds wait db-instance-available --db-instance-identifier itmo444-db

aws rds create-db-instance-read-replica --db-instance-identifier itmo444-db-replica --source-db-instance-identifier itmo444-db


#arbitrary sleep, might need to wait more...
sleep 300

firefox $lburl &












