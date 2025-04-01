#!/bin/bash

NAMES="$@"
IMAGE_ID="ami-0b4f379183e5706b9"
SECURITY_GROUP_ID="sg-0a59af9515bb8476e"

for i in "$@"
do 
    if [[ "$i" == "mongodb" || "$i" == "mysql" ]]; then
        INSTANCE_TYPE="t3.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    echo "Creating $i instance..."
    
    # Run AWS EC2 instance creation command
    IP_ADDRESS=$(aws ec2 run-instances \
        --image-id "$IMAGE_ID" \
        --instance-type "$INSTANCE_TYPE" \
        --security-group-ids "$SECURITY_GROUP_ID" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')

    echo "Created $i instance: $IP_ADDRESS"
done
