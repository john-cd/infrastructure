## Create an auto-scaling group of Bastion servers, allowing SSH access to the private EC2 instances
## Inspired by 
## https://registry.terraform.io/modules/kurron/bastion/aws/0.9.0
## https://github.com/kurron/terraform-aws-bastion

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

resource "aws_key_pair" "bastion_key" {
  key_name_prefix = "${var.application_name}-${var.environment_name}-bastion-key-"
  public_key = "${file(format("%s/%s", path.root, var.public_key_path))}"
}

resource "aws_launch_configuration" "bastion_lc" {
  name_prefix                 = "${var.application_name}-${var.environment_name}-bastion-launch-config-"
  image_id                    = "${data.aws_ami.amazon_linux_ami.id}"
  instance_type               = "${var.bastion_instance_type}"
  key_name                    = "${aws_key_pair.bastion_key.key_name}"
  security_groups             = ["${list(module.ssh-security-group.this_security_group_id, module.bastion_source_security_group.this_security_group_id)}"]
  associate_public_ip_address = true
  enable_monitoring           = false

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion_asg" {
  name_prefix               = "${var.application_name}-${var.environment_name}-bastion-asg-"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  default_cooldown          = "${var.cooldown}"
  launch_configuration      = "${aws_launch_configuration.bastion_lc.name}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type         = "EC2"
  desired_capacity          = "${var.desired_capacity}"
  vpc_zone_identifier       = ["${var.public_subnet_ids}"]
  termination_policies      = ["ClosestToNextInstanceHour", "OldestInstance", "Default"]
  enabled_metrics           = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.application_name}-${var.environment_name}-bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "Application"
    value               = "${var.application_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Description"
    value               = "Bastion server auto-scaling group. SSH there to access internal instances within the VPC"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_schedule" "scale_up" {
  autoscaling_group_name = "${aws_autoscaling_group.bastion_asg.name}"
  scheduled_action_name  = "Scale Up"
  recurrence             = "${var.scale_up_cron}"
  min_size               = "${var.min_size}"
  max_size               = "${var.max_size}"
  desired_capacity       = "${var.desired_capacity}"
}

resource "aws_autoscaling_schedule" "scale_down" {
  autoscaling_group_name = "${aws_autoscaling_group.bastion_asg.name}"
  scheduled_action_name  = "Scale Down"
  recurrence             = "${var.scale_down_cron}"
  min_size               = "${var.scale_down_min_size}"
  max_size               = "${var.max_size}"
  desired_capacity       = "${var.scale_down_desired_capacity}"
}
