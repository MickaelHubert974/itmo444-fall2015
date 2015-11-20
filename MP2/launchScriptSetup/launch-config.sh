#!/bin/bash

aws autoscaling create-launch-configuration --launch-configuration-name itmo444-launch-config --iam-instance-profile phpdevelopperRole --user-data file://../environmentSetup/install-env.sh  --image-id $1 --security-groups $2 --instance-type $3 --key-name $4 --associate-public-ip-address --user-data file://../environmentSetup/install-env.sh 

aws autoscaling create-auto-scaling-group --auto-scaling-group-name itmo444-scaling-group --launch-configuration-name itmo444-launch-config --load-balancer-names itmo444-lb --health-check-type ELB --min-size 3 --max-size 6 --desired-capacity 3 --default-cooldown 600 --health-check-grace-period 120 --availability-zones us-east-1a
