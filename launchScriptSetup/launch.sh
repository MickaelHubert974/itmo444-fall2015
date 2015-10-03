#!/bin/bash

aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --security-group-ids $4 --subnet-id $5 --associate-public-ip-address --key-name $6 --user-data https://github.com/MickaelHubert974/itmo444-fall2015/blob/master/environmentSetup/install-env.sh --profile mickaelhubert

