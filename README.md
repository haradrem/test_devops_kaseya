# test_devops_kaseya
CLI tool for resizing EC2 primary EBS volume

Hi! 
For using this tool you must have alredy installed and configured AWS cli and also you must have ssh key or credentials for instance that you want to change
This tool contains two scripts:

Change_EBS.sh - this script is the main entry point. It accepts name of instance, size of EBS volume that you want, username and ssh key location or credentials. It modify EBS volume, then push and execute second scrypt on instance to confirm changes

Change_EBS_vpc_side.sh - this script confirm changes of partition size and filesystem on the instance without downtime

This two scripts must be in same directory.

For start just execute Change_EBS.sh
