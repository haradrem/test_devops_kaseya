#!/bin/bash

#Check and change partition size

MAIN_PARTITION_NAME="$(lsblk -r | grep -w "/" | awk '{print $1}')"

MAIN_PARTITION_NAME2=${MAIN_PARTITION_NAME:0:-1}' '${MAIN_PARTITION_NAME: -1:1}

#echo "this is main partition name: $MAIN_PARTITION_NAME"

sudo growpart /dev/$MAIN_PARTITION_NAME2

#Check and change filesystem

FILESYSTEM_TYPE="$(df -PT | awk 'NR==2 {print $2}')"
#echo "this is filesystem type: $FILESYSTEM_TYPE "

if [ "$FILESYSTEM_TYPE" == "ext4" ] || [ "$FILESYSTEM_TYPE" == "ext3" ] || [ "$FILESYSTEM_TYPE" == "ext2" ] ; then
  sudo resize2fs /dev/$MAIN_PARTITION_NAME
else
  sudo xfs_growfs -d /
fi
