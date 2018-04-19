############################################
# K8s Worker Instances (aka Nodes, Minions)
############################################

module "worker_asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  name = "service"

  # Launch configuration
  lc_name = "${var.application_name}-${var.environment_name}-k8s-worker-launch-config"

  image_id        = "${data.aws_ami.amazon_linux_ami.id}"
  instance_type   = "${var.worker_instance_type}"
  security_groups = ["${aws_security_group.kubernetes_cluster_sg.id}"]

  associate_public_ip_address = false
  enable_monitoring           = false
  iam_instance_profile        = ""                            # TODO
  placement_group             = ""                            # TODO
  key_name                    = "${var.default_keypair_name}"

  /*
  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]
  */

  root_block_device = [
    {
      volume_size = "8"
      volume_type = "gp2"
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.application_name}-${var.environment_name}-k8s-worker-asg"
  vpc_zone_identifier       = "${var.worker_subnet_ids}"
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = "${var.worker_count}"
  desired_capacity          = "${var.worker_count}"
  wait_for_capacity_timeout = 0

  tags_as_map = {
    Name            = "${var.application_name}-${var.environment_name}-k8s-worker"	  
    Application     = "${var.application_name}"
    Environment     = "${var.environment_name}"
    ansibleFilter   = "${var.ansibleFilter}"
    ansibleNodeType = "worker"
    ansibleNodeName = "worker"                                         
  }
}
