output "bastion_source_security_group_id" {
  description = "ID of the security group  for communication between bastion servers and private subnets"
  value       = "${module.bastion_source_security_group.this_security_group_id}"
}

## Bastion Launch Config and Autoscaling Group 

output "ami_id" {
  value       = "${data.aws_ami.amazon_linux_ami.id}"
  description = "ID of the selected AMI"
}

output "launch_configuration_id" {
  value       = "${aws_launch_configuration.bastion_lc.id}"
  description = "ID of the Bastion's launch configuration"
}

output "launch_configuration_name" {
  value       = "${aws_launch_configuration.bastion_lc.name}"
  description = "Name of the Bastion's launch configuration"
}

output "auto_scaling_group_id" {
  value       = "${aws_autoscaling_group.bastion_asg.id}"
  description = "ID of the Bastion's auto scaling group"
}

output "auto_scaling_group_name" {
  value       = "${aws_autoscaling_group.bastion_asg.name}"
  description = "Name of the Bastion's auto scaling group"
}

output "bastion_ec2_key_name" {
  value       = "${aws_key_pair.bastion_key.key_name}"
  description = "Name of the EC2 SSH key that should be used to log on bastion servers"
}
