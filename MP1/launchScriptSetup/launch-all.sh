#!/bin/bash

declare -a instancesID

mapfile -t instancesID < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --security-group-ids $4 --subnet-id $5 --associate-public-ip-address --key-name $6 --user-data file://../environmentSetup/install-webserver.sh --iam-instance-profile Name=phpdevelopperRole --output table | grep InstanceId | sed "s/|//g" | sed "s/ //g" | sed "s/InstanceId//g")

echo ${instancesID[@]}

aws ec2 wait instance-running --instance-ids ${instancesID[@]}

aws elb create-load-balancer --load-balancer-name itmo444-lb --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --subnets $5 --security-groups $4

declare -a IDARRAY
IDARRAY=(`aws ec2 describe-instances --output table | grep InstanceId | sed "s/|//g" | sed "s/ //g" | sed "s/InstanceId//g"`)

aws elb register-instances-with-load-balancer --load-balancer-name itmo444-lb --instances ${IDARRAY[@]}

aws elb configure-health-check --load-balancer-name itmo444-lb --health-check Target=HTTP:80/png,Interval=30,UnhealthyThreshold=2,HealthyThreshold=2,Timeout=3

aws autoscaling create-launch-configuration --launch-configuration-name itmo444-launch-config --iam-instance-profile phpdevelopperRole --user-data file://../environmentSetup/install-env.sh  --image-id $1 --security-groups $4 --instance-type $3 --key-name $6 --associate-public-ip-address --user-data file://../environmentSetup/install-env.sh 

aws autoscaling create-auto-scaling-group --auto-scaling-group-name itmo444-scaling-group --launch-configuration-name itmo444-launch-config --load-balancer-names itmo444-lb --health-check-type ELB --min-size 3 --max-size 6 --desired-capacity 3 --default-cooldown 600 --health-check-grace-period 120 --vpc-zone-identifier $5


declare -a scaleupPolicy

scaleupPolicy=(`aws autoscaling put-scaling-policy --policy-name scaleup-policy --auto-scaling-group-name itmo444-scaling-group --scaling-adjustment 1 --adjustment-type ChangeInCapacity`)

declare -a scaledownPolicy

scaledownPolicy=(`aws autoscaling put-scaling-policy --policy-name scaledown-policy --auto-scaling-group-name itmo444-scaling-group --scaling-adjustment -1 --adjustment-type ChangeInCapacity`)

aws cloudwatch put-metric-alarm --alarm-name cpumore30 --alarm-description "Alarm if CPU exceeds 30 percent" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 30 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=AutoScalingGroupName,Value=<itmo444-scaling-group>" --evaluation-periods 2 --alarm-actions $scaleupPolicy

aws cloudwatch put-metric-alarm --alarm-name cpuless30 --alarm-description "Alarm if CPU beleow 10 percent" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 10 --comparison-operator LessThanOrEqualToThreshold  --dimensions "Name=AutoScalingGroupName,Value=<itmo444-scaling-group>" --evaluation-periods 2 --alarm-actions $scaledownPolicy

#database
#aws rds create-db-instance --db-instance-identifier itmo444-db --allocated-storage 5 --db-instance-class db.m1.small --engine mysql --master-username myawsuser --master-user-password myawsuser

