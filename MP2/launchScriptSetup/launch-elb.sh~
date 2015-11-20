#! /bin/bash

aws elb create-load-balancer --load-balancer-name $1 --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $2 --security-groups $3

declare -a IDARRAY
IDARRAY=(`aws ec2 describe-instances --output table | grep InstanceId | sed "s/|//g" | sed "s/ //g" | sed "s/InstanceId//g"`)

aws elb register-instances-with-load-balancer --load-balancer-name $1 --instances ${IDARRAY[@]}

aws elb configure-health-check --load-balancer-name $1 --health-check Target=HTTP:80/png,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3

#aws autoscaling attach-load-balancers --auto-scaling-group-name my-asg --load-balancer-names $1

#aws autoscaling describe-load-balancers --auto-scaling-group-name my-asg

#aws autoscaling update-auto-scaling-group --auto-scaling-group-name my-asg –-health-check-type ELB –-health-check-grace-period 300


