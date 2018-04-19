############
## Security
############


resource "aws_security_group" "kubernetes_cluster_sg" {
  vpc_id = "${var.vpc_id}"
  name   = "${var.application_name}-${var.environment_name}-kubernetes-sg"

  description = "Security group for all servers in the Kubernetes cluster"
  
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all ipv6 outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    ipv6_cidr_blocks = ["::/0"]
  }
    
  # Allow all internal from bastion_source_security_group_id (maintenance)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = ["${var.bastion_source_security_group_id}"]
  }

  # Allow all traffic from the API ELB
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.kubernetes_elb_sg.id}"]
  }

  tags {
    Name        = "${var.application_name}-${var.environment_name}-kubernetes-cluster-sg"
    Application = "${var.application_name}"
    Environment = "${var.environment_name}"
  }
}
