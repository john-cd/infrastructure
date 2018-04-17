
//
// Slave Firewall
// From: https://github.com/apache/spark/blob/v1.4.1/ec2/spark_ec2.py#L504-L526
// See https://github.com/hashicorp/atlas-examples/blob/master/spark/terraform/firewalls-spark-slave.tf
resource "aws_security_group" "spark_slave_sg" {
    name = "${var.application_name}-${var.environment_name}-spark-slave-sg"
    description = "Spark Slave"

    vpc_id = "${var.vpc_id}"
	
	# Note that when you create 2 security groups circular dependencies are created. When destroying the terraformed infrastructure in such a case, you need to delete the associations of the security groups before deleting the groups themselves. 
	revoke_rules_on_delete = true
  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
 
  tags {
    Name = "${var.application_name}-${var.environment_name}-spark-slave-sg"
	Application = "${var.application_name}"
	Environment = "${var.environment_name}"
  }	
}

// slave - self firewalls

resource "aws_security_group_rule" "spark_slave_icmp_self" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    self = true
}

resource "aws_security_group_rule" "spark_slave_sg_tcp_all_self" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark_slave_udp_all_self" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark_slave_icmp_all_master" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    source_security_group_id = "${aws_security_group.spark_master_sg.id}"
}

resource "aws_security_group_rule" "spark_slave_tcp_all_master" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark_master_sg.id}"
}

resource "aws_security_group_rule" "spark_slave_udp_all_master" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark_master_sg.id}"
}


# Web
resource "aws_security_group_rule" "spark_slave_web" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8443
    to_port = 8443
	source_security_group_id = "${var.bastion_security_group_id}"
}

# SSH
resource "aws_security_group_rule" "spark_slave_ssh" {
    security_group_id = "${aws_security_group.spark_slave_sg.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
	source_security_group_id = "${var.bastion_security_group_id}"
}


