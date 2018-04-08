
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "1.9.1"
  
  name = "stage"

  create_vpc = true
  
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_s3_endpoint = true
  map_public_ip_on_launch = false

  vpc_tags = {}

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
 
}