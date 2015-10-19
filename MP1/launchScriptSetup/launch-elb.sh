#! /bin/bash

aws elb create-load-balancer --load-balancer-name $1 --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $2 --security-groups $3

declare -a IDARRAY
IDARRAY=(`aws ec2 describe-instances --output table | grep InstanceId | sed "s/|//g" | sed "s/ //g" | sed "s/InstanceId//g"`)

aws elb register-instances-with-load-balancer --load-balancer-name $1 --instances ${IDARRAY[@]}
