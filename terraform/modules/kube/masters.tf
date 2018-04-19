############################
# K8s Control Pane instances
############################

module "master_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "${var.application_name}-${var.environment_name}-k8s-master"

  # Launch configuration
  lc_name = "${var.application_name}-${var.environment_name}-k8s-master-launch-config"

  image_id        = "${data.aws_ami.amazon_linux_ami.id}"
  instance_type   = "${var.master_instance_type}"
  security_groups = ["${aws_security_group.kubernetes_cluster_sg.id}"]

  associate_public_ip_address = false
  enable_monitoring           = false
  iam_instance_profile        = "${aws_iam_instance_profile.kubernetes.id}"
  placement_group             = ""                                          # TODO
  key_name                    = "${var.default_keypair_name}"

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.application_name}-${var.environment_name}-k8s-master-asg"
  vpc_zone_identifier       = "${var.master_subnet_ids}"
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = "${var.master_count}"
  desired_capacity          = "${var.master_count}"
  wait_for_capacity_timeout = 0

  tags_as_map = {
    Name            = "${var.application_name}-${var.environment_name}-k8s-master" 
    Application     = "${var.application_name}"
    Environment     = "${var.environment_name}"
    ansibleFilter   = "${var.ansibleFilter}"
    ansibleNodeType = "controller"
    ansibleNodeName = "controller"   
  }
}

## Create a new load balancer attachment

resource "aws_autoscaling_attachment" "master_asg_attachment" {
  autoscaling_group_name = "${module.master_asg.this_autoscaling_group_id}"
  elb                    = "${aws_elb.kubernetes_elb.id}"
}

###############################
## Kubernetes API Load Balancer
###############################

resource "aws_elb" "kubernetes_elb" {
  name                      = "${var.application_name}-${var.environment_name}-k8s-elb"
  subnets                   = ["${var.worker_subnet_ids}"]
  internal = true
  cross_zone_load_balancing = true
  idle_timeout              = 400

  connection_draining         = true
  connection_draining_timeout = 400

  security_groups = ["${aws_security_group.kubernetes_elb_sg.id}"]
  listener {
    lb_port           = 6443
    instance_port     = 6443
    lb_protocol       = "TCP"
    instance_protocol = "TCP"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 15
    target              = "HTTP:8080/healthz"
    interval            = 30
  }
  tags {
    Name        = "${var.application_name}-${var.environment_name}-k8s-elb"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }

  /* TODO
	access_logs {
		bucket        = "${var.bucket}"
		bucket_prefix = "${var.application_name}/${var.environment_name}/kube/elb"
		interval      = 60
	}*/
}

############
## Security
############

resource "aws_security_group" "kubernetes_elb_sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.application_name}-${var.environment_name}-k8s-elb-sg"

  description = "Source security group of the ELB fronting the Kubernetes cluster"
  
  # Allow inbound traffic to the port used by Kubernetes API HTTPS
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "TCP"
    security_groups = ["${var.bastion_source_security_group_id}"]  # TODO allow ingress from some other sources than just bastion servers
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.application_name}-${var.environment_name}-k8s-elb-sg"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }
}

############
## Outputs
############

output "kubernetes_api_dns_name" {
  value = "${aws_elb.kubernetes_elb.dns_name}"
}
