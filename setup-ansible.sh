#! /usr/bin/env bash

## Boto configuration (for ec2.py):

# AWS_SHARED_CREDENTIALS_FILE does not seem to work
# instead --> source credentials/keys.sh

#export AWS_SHARED_CREDENTIALS_FILE=$(pwd)/credentials/credentials
#echo "credentials: $AWS_SHARED_CREDENTIALS_FILE"
##optionally: export AWS_PROFILE = "default"

##OR use directly
#export AWS_ACCESS_KEY_ID='AK123'
#export AWS_SECRET_ACCESS_KEY='abc123'


## ec2.py inventory script configuration

#export EC2_INI_PATH=ansible/inventory/ec2.ini


## Ansible configuration:

export ANSIBLE_CONFIG=$(pwd)/ansible/config/ansible.cfg

## override specific settings:
export ANSIBLE_INVENTORY=$(pwd)/ansible/inventory
echo "inventory: $ANSIBLE_INVENTORY"
export ANSIBLE_HOST_KEY_CHECKING=False

## Check Ansible configuration 
#ansible-config view --config ansible/config/ansible.cfg

ansible all --list-hosts



