## Locate the Amazon Linux AMI

data "aws_ami" "amazon_linux_ami" {
  most_recent = true
  name_regex  = "amzn-ami-hvm-*"
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "hypervisor"
    values = ["xen"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
