## Goals

- Automatically provision the infrastructure in AWS: 
- Provision global resources (IAM, Route 53...)
- Provision the network (VPC, subnets, gateways...) 
- Provision the machines (EC2 instances, autoscaling groups, etc...)


## Links

[Terraform Registry]( https://registry.terraform.io/ )


## Terraform basic commands cheatsheet

```shell
terraform init
```

```shell
terraform apply
```

Set variables directly on the command-line with the ``-var`` flag or create a file named ``terraform.tfvars`` 

```shell
terraform apply \
  -var 'access_key=foo' \
  -var 'secret_key=bar'
```

```shell
terraform apply \
  -var-file="secret.tfvars" \
  -var-file="production.tfvars"
```

```shell
terraform plan
```


```shell
terraform show
```

When done with the infrastructure:

```shell
terraform destroy
```

### Set up Remote State

To configure Terraform to use this S3 bucket, with encryption enabled, run the following command,

```shell
 terraform remote config \
    -backend=s3 \
    -backend-config="bucket=(YOUR_BUCKET_NAME)" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=(YOUR_BUCKET_REGION)" \
    -backend-config="encrypt=true"
```

[Source]( https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa )

