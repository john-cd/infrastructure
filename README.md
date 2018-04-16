__WORK IN PROGRESS__


## Useful Links

[Ansible doc]( docs/Ansible.md )
[Terraform doc]( docs/Terraform.md )

## Goals

Automation of the infrastructure for a REST API endpoint hosted on AWS

- Resource Provisioning via Terraform
- Deployment on K8s via Helm on Kubernetes
- Configuration management via Ansible

See README.md files in each subdirectory.

### Terraform Goals

- Automatically provision the infrastructure in AWS: 
	- Provision global resources (IAM users and groups, Route 53 records, EC2 key_pair...)
	- Provision the network (VPC, subnets, internet and egress gateways, route tables...) 
	- Provision the machines (EC2 instances, autoscaling groups, etc...)
	- Install Kubernetes

### Helm Goals

- Deploy Helm charts on K8s 
	
## Deployment

### Prerequisites

- Create a ``credentials`` file in the ``credentials`` folder

```
[default]
aws_access_key_id = ...
aws_secret_access_key = ...
```

- Create an EC2 key pair (called ``main-ec2-key`` by default) in the ``credentials`` folder. 
See [instructions]( ./terraform/modules/key_pair/README.md )

- If necessary, create a configuration S3 bucket (e.g. using the AWS Console). Enable bucket versioning.  

- Install autocomplete (optional)

```shell
terraform -install-autocomplete
```

### Terraform deployment

From the root of the repo:

```shell
terraform init ./layers/mgmt
```

Or to pass a backend config file

```shell
terraform init -backend-config=./layers/mgmt/backend-mgmt.conf ./layers/mgmt
```

To override specific backend configuration items (e.g. storage location of the terraform.tfstate file and access credentials):

```shell
terraform init ./layers/mgmt \
	-backend-config="bucket = (YOUR_BUCKET_NAME)"
	-backend-config="region = (YOUR_BUCKET_REGION)"
	-backend-config="shared_credentials_file = ~/.aws/credentials"
```
	
Validate the config files and display the execution plan:

```shell
terraform validate ./layers/mgmt
```

Note: you can override the default values for the root module variables by passing the ``.tfvars`` file

```shell
terraform validate -var-file=./layers/mgmt/mgmt.tfvars ./layers/mgmt
```

### Verify the Terraform execution plan then apply it

```shell
terraform plan ./layers/mgmt

#or
terraform plan -var-file=./layers/mgmt/mgmt.tfvars ./layers/mgmt
```

After review of the plan, create the resources:

```shell
terraform apply ./layers/mgmt

#or
terraform apply -var-file=./layers/mgmt/mgmt.tfvars ./layers/mgmt
```

### After deployment

Cluster credentials are written beneath the generated/ directory, including any generated CA certificate and a kubeconfig file. You can use this to access the cluster with kubectl. This is the only method of access for a Kubernetes cluster installed without Tectonic features:

```shell
export KUBECONFIG=generated/auth/kubeconfig
kubectl cluster-info
```

## Folder Layout

- ``credentials``: stores AWS access key and secret key(s) and EC2 instance key pairs
- ``layers``: the multiple layers of the application, each deployed independently. Example: management layer; Kubernetes / API layer; Spark / Big Data layer
- ``terraform``: shared Terraform modules
- ``helm``: shared Helm charts






 