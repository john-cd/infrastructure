__WORK IN PROGRESS__

# Goals

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
terraform init ./resources
```

To override the backend configuration (e.g. storage location of the terraform.tfstate file and access credentials):

```shell
terraform init ./resources \
	-backend-config="bucket = (YOUR_BUCKET_NAME)"
	-backend-config="region = (YOUR_BUCKET_REGION)"
	-backend-config="shared_credentials_file = ~/.aws/credentials"
```
	
Validate the config files and display the execution plan:

```shell
terraform validate ./resources 
terraform plan ./resources
```

After review of the plan, create resources:

```shell
terraform apply ./resources
```

### After deployment

Cluster credentials are written beneath the generated/ directory, including any generated CA certificate and a kubeconfig file. You can use this to access the cluster with kubectl. This is the only method of access for a Kubernetes cluster installed without Tectonic features:

```shell
export KUBECONFIG=generated/auth/kubeconfig
kubectl cluster-info
```

## Folder Layout

- ``credentials``: stores AWS access key and secret key
- ``resources``: actual resources to be created
- ``terraform``: shared Terraform modules
- ``helm``: shared Helm charts






 