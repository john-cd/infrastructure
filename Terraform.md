# Terraform Cheatsheet

## Links

[Terraform Registry]( https://registry.terraform.io/ )


## Terraform basic commands

```shell
terraform init
```

Format config files

```shell
terraform fmt 
```

Validate config files

```shell
terraform validate
```

```shell
terraform plan
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
terraform show
```

When done with the infrastructure:

```shell
terraform destroy
```

### Set up Remote State

To configure Terraform to use a S3 bucket, with encryption enabled, run the following command,

```shell
 terraform init \
    -backend-config="bucket=(YOUR_BUCKET_NAME)" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=(YOUR_BUCKET_REGION)" \
    -backend-config="encrypt=true"
```

[Source (older)]( https://blog.gruntwork.io/how-to-manage-terraform-state-28f5697e68fa )
[Backends Doc]( https://www.terraform.io/docs/backends/index.html ) 

