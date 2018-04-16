#!/usr/bin/env bash

# AWS_SHARED_CREDENTIALS_FILE does not seem to work
# instead --> source credentials/keys.sh

# export AWS_SHARED_CREDENTIALS_FILE=$(pwd)/credentials/credentials

##OR use directly
#export AWS_ACCESS_KEY_ID='AK123'
#export AWS_SECRET_ACCESS_KEY='abc123'

ansible/inventory/ec2.py --list