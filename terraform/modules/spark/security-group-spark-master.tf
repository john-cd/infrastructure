//
// Master Firewall
// From: https://github.com/apache/spark/blob/v1.4.1/ec2/spark_ec2.py#L468-L527
// See https://github.com/hashicorp/atlas-examples/blob/master/spark/terraform/firewalls-spark-master.tf
 
resource "aws_security_group" "spark_master_sg" {
    name = "${var.application_name}-${var.environment_name}-spark-master"
    description = "Spark Master Security Group"
    vpc_id = "${var.vpc_id}"
	
    # Avoid circular dependencies stopping the destruction of the cluster
    revoke_rules_on_delete = true
	
	  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
 
  tags {
	Name = "${var.application_name}-${var.environment_name}-spark-master-sg"
	Application = "${var.application_name}"
	Environment = "${var.environment_name}"
  }
	
}

// master - self firewalls

resource "aws_security_group_rule" "spark_master_icmp_self" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    self = true
}

resource "aws_security_group_rule" "spark_master_tcp_all_self" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark_master_udp_all_self" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark_master_icmp_all_slave" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    source_security_group_id = "${aws_security_group.spark_slave_sg.id}"
}

resource "aws_security_group_rule" "spark_master_tcp_all_slave" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark_slave_sg.id}"
}

resource "aws_security_group_rule" "spark_master_udp_all_slave" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark_slave_sg.id}"
}

# Web
resource "aws_security_group_rule" "spark_master_web" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8443
    to_port = 8443
    source_security_group_id = "${var.bastion_security_group_id}"
}

# SSH
resource "aws_security_group_rule" "spark_master_ssh" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
	source_security_group_id = "${var.bastion_security_group_id}"
}

#### Expose web interfaces to VPN

# Yarn
resource "aws_security_group_rule" "spark_master_yarn" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8088
    to_port = 8088
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Spark History
resource "aws_security_group_rule" "spark_master_spark_history" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 18080
    to_port = 18080
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Zeppelin
 resource "aws_security_group_rule" "spark_master_zeppelin" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8890
    to_port = 8890
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Spark UI
 resource "aws_security_group_rule" "spark_master_spark_UI" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 4040
    to_port = 4040
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Ganglia
 resource "aws_security_group_rule" "spark_master_ganglia" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    source_security_group_id = "${var.bastion_security_group_id}"
  }

# Hue
 resource "aws_security_group_rule" "spark_master_hue" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "ingress"
    from_port   = 8888
    to_port     = 8888
    protocol    = "TCP"
    source_security_group_id = "${var.bastion_security_group_id}"
  }
  
  
/* TODO verify if we need  
  
## Egress
  
resource "aws_security_group_rule" "spark_master_egress" {
    security_group_id = "${aws_security_group.spark_master_sg.id}"
    type = "egress"
    protocol = "-1"
    from_port = 0
    to_port = 0
	cidr_blocks = ["0.0.0.0/0"]
}

*/


