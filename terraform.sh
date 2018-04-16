#!/usr/bin/env bash

# Expects
#- a command (plan or apply)  
#- an environment name e.g. dev, staging, prod or mgmt (for the management layer, which has only one env.)
#- a path to a Terraform root module (e.g. under the layers folder) 

command=$1
env=$2
path=$3

if [ "$command" -eq "apply" ]
then
  terraform apply -var-file=${path}/${env}.tfvars  ${path}
else
  terraform get  -update=true
  terraform init -backend-config=${path}/backend-${env}.conf  ${path}
  terraform plan -var-file=${path}/${env}.tfvars   ${path}
fi


