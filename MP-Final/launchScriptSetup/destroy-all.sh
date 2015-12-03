#!/bin/bash

declare -a cleanupARR
declare -a cleanupLBARR
declare -a dbInstanceARR

aws ec2 describe-instances --filter Name=instance-state-code,Values=16 --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g"

mapfile -t cleanupARR < <(aws ec2 describe-instances --filter Name=instance-state-code,Values=16 --output table | grep InstanceId | sed "s/|//g" | tr -d ' ' | sed "s/InstanceId//g")

echo "the output is ${cleanupARR[@]}"

aws ec2 terminate-instances --instance-ids ${cleanupARR[@]} 

echo "Cleaning up existing Load Balancers"
mapfile -t cleanupLBARR < <(aws elb describe-load-balancers --output json | grep LoadBalancerName | sed "s/[\"\:\, ]//g" | sed "s/LoadBalancerName//g")

echo "The LBs are ${cleanupLBARR[@]}"

LENGTH=${#cleanupLBARR[@]}
echo "ARRAY LENGTH IS $LENGTH"
for (( i=0; i<${LENGTH}; i++)); 
  do
  aws elb delete-load-balancer --load-balancer-name ${cleanupLBARR[i]} --output text
  sleep 1
done

# Delete existing RDS  Databases
# Note if deleting a read replica this is not your command 
mapfile -t dbInstanceARR < <(aws rds describe-db-instances --output json | grep "\"DBInstanceIdentifier" | sed "s/[\"\:\, ]//g" | sed "s/DBInstanceIdentifier//g" )

if [ ${#dbInstanceARR[@]} -gt 0 ]
   then
   echo "Deleting existing RDS database-instances"
   LENGTH=${#dbInstanceARR[@]}  

   # http://docs.aws.amazon.com/cli/latest/reference/rds/wait/db-instance-deleted.html
      for (( i=0; i<${LENGTH}; i++));
      do 
      aws rds delete-db-instance --db-instance-identifier ${dbInstanceARR[i]} --skip-final-snapshot --output text
      aws rds wait db-instance-deleted --db-instance-identifier ${dbInstanceARR[i]} --output text
      sleep 1
   done
fi

# Delete Launchconf and Autoscaling groups

LAUNCHCONF=(`aws autoscaling describe-launch-configurations --output json | grep LaunchConfigurationName | sed "s/[\"\:\, ]//g" | sed "s/LaunchConfigurationName//g"`)

SCALENAME=(`aws autoscaling describe-auto-scaling-groups --output json | grep AutoScalingGroupName | sed "s/[\"\:\, ]//g" | sed "s/AutoScalingGroupName//g"`)

echo "The asgs are: " ${SCALENAME[@]}
echo "the number is: " ${#SCALENAME[@]}

if [ ${#SCALENAME[@]} -gt 0 ]
  then
echo "SCALING GROUPS to delete..."

aws autoscaling update-auto-scaling-group --auto-scaling-group-name $SCALENAME --min-size 0 --max-size 0

sleep 1000

aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name $SCALENAME

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $SCALENAME
aws autoscaling delete-launch-configuration --launch-configuration-name $LAUNCHCONF
fi

# Delete sns topic and subscriptions
echo "Deleting sns topic and subscriptions"
aws sns delete-topic --topic-arn "arn:aws:sns:us-east-1:519662356897:ImageUploaded"
SUBSCRIPTIONS=(`aws sns list-subscriptions --output json | grep SubscriptionArn | sed "s/\"SubscriptionArn\": //g" | sed "s/\"//g"`)
aws sns unsubscribe --subscription-arn ${SUBSCRIPTIONS[@]}

# Delete s3 buckets
echo "Deleting s3 buckets"
BUCKETS=(`aws s3 ls | grep php-mh | cut -c21- | sed 's/php/s3:\/\/php/g'`)
LENGTH=${#BUCKETS[@]}
for (( i=0; i<${LENGTH}; i++));
      do 
      aws s3 rb ${BUCKETS[i]} --force
      sleep 1
      done


echo "All done"
