#!/bin/bash

#launch configuration

aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --security-group-ids $4 --subnet-id $5 --associate-public-ip-address --key-name $6 --user-data file://../environmentSetup/install-env.sh --iam-instance-profile $7

aws ec2 wait instance-running
