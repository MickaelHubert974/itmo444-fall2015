#!/bin/bash


declare -a instancesID

mapfile -t instancesID < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --security-group-ids $4 --subnet-id $5 --associate-public-ip-address --key-name $6 --user-data file://../environmentSetup/install-env.sh --iam-instance-profile Name=phpdevelopperRole --output table | grep InstanceId | sed "s/|//g" | sed "s/ //g" | sed "s/InstanceId//g")


echo ${instancesID[@]}

aws ec2 wait instance-running --instance-ids ${instancesID[@]}



