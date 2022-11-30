#!/bin/bash
# read instance tag
echo -n "Enter instance name: "
read INSTANCE_NAME

#aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME"
#echo "this is instance name: $INSTANCE_NAME"

PUBLIC_IP="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" --output text --query "Reservations[*].Instances[*].PublicIpAddress")"
echo "this is instance public IP: $PUBLIC_IP"

INSTANCE_ID="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" --output text --query "Reservations[*].Instances[*].InstanceId")"
echo "this is instance ID: $INSTANCE_ID"

VOLUME_ID="$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" --output text --query 'Reservations[*].Instances[*].BlockDeviceMappings[*].Ebs.[VolumeId]')"
echo "this is volume_id: $VOLUME_ID"

echo "What size of the EBS volume do you want?"
read EBS_SIZE

aws ec2 modify-volume --size $EBS_SIZE --volume-id $VOLUME_ID

############################

function for_access () {
echo -n "You connect to this instance with password or with key? Please type key or password: "
read ACCESS_ANSWER

if [ "$ACCESS_ANSWER" == "key" ]; then
  echo "Enter key location:"
  read KEY_LOCATION
#  echo $KEY_LOCATION
  scp -i $KEY_LOCATION vpc_side.sh $INSTANCE_USERNAME@$PUBLIC_IP:/tmp/
  ssh -i $KEY_LOCATION -t $INSTANCE_USERNAME@$PUBLIC_IP "sudo -s bash /tmp/change_EBS_vpc_side.sh && rm /tmp/change_EBS_vpc_side.sh"
elif [ "$ACCESS_ANSWER" == "password" ]; then
  echo "Enter password for copy scrypt on instance: "
  scp -i $KEY_LOCATION vpc_side.sh $INSTANCE_USERNAME@$PUBLIC_IP:/tmp/
  echo "Enter password for executing scrypt on instance: "
  ssh -i $KEY_LOCATION -t $INSTANCE_USERNAME@$PUBLIC_IP "sudo -s bash /tmp/change_EBS_vpc_side.sh && rm /tmp/change_EBS_vpc_side.sh"
#  echo $INSTANCE_PASSWORD
else
  echo "Sorry, I dont understand, try again"
  for_access

fi
}

############################

echo "For applying changes on instance, you have to enter credentionals"

echo "Enter instance username for connection: "
read INSTANCE_USERNAME

for_access

echo "Resizing done for instance $INSTANCE_NAME "
