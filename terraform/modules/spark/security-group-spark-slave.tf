
//
// Slave Firewall
// From: https://github.com/apache/spark/blob/v1.4.1/ec2/spark_ec2.py#L504-L526
// See https://github.com/hashicorp/atlas-examples/blob/master/spark/terraform/firewalls-spark-slave.tf
resource "aws_security_group" "spark-slave" {
    name = "spark-slave"
    description = "Spark Slave"

    vpc_id = "${var.vpc_id}"
	
	# Note that when you create 2 security groups circular dependencies are created. When destroying the terraformed infrastructure in such a case, you need to delete the associations of the security groups before deleting the groups themselves. 
	revoke_rules_on_delete = true
	  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
 
  tags {
    name = "spark-slave-security-group"
  }
  
	
}

// slave - self firewalls

resource "aws_security_group_rule" "spark-slave-icmp-self" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    self = true
}

resource "aws_security_group_rule" "spark-slave-tcp-all-self" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark-slave-udp-all-self" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark-slave-icmp-all-master" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    source_security_group_id = "${aws_security_group.spark-master.id}"
}

resource "aws_security_group_rule" "spark-slave-tcp-all-master" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark-master.id}"
}

resource "aws_security_group_rule" "spark-slave-udp-all-master" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark-master.id}"
}


# Web
resource "aws_security_group_rule" "spark-slave-web" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8443
    to_port = 8443
	source_security_group_id = "${var.bastion_security_group_id}"
}

# SSH
resource "aws_security_group_rule" "spark-slave-ssh" {
    security_group_id = "${aws_security_group.spark-slave.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
	source_security_group_id = "${var.bastion_security_group_id}"
}


