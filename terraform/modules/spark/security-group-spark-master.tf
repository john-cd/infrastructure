//
// Master Firewall
// From: https://github.com/apache/spark/blob/v1.4.1/ec2/spark_ec2.py#L468-L527
// See https://github.com/hashicorp/atlas-examples/blob/master/spark/terraform/firewalls-spark-master.tf
 
resource "aws_security_group" "spark-master" {
    name = "spark-master"
    description = "Spark Master"
    vpc_id = "${var.vpc_id}"
	
    # Avoid circular dependencies stopping the destruction of the cluster
    revoke_rules_on_delete = true
	
	  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
 
  tags {
    name = "spark-master-security-group"
  }
	
}

// master - self firewalls

resource "aws_security_group_rule" "spark-master-icmp-self" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    self = true
}

resource "aws_security_group_rule" "spark-master-tcp-all-self" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark-master-udp-all-self" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    self = true
}

resource "aws_security_group_rule" "spark-master-icmp-all-slave" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "icmp"
    from_port = -1
    to_port = -1
    source_security_group_id = "${aws_security_group.spark-slave.id}"
}

resource "aws_security_group_rule" "spark-master-tcp-all-slave" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark-slave.id}"
}

resource "aws_security_group_rule" "spark-master-udp-all-slave" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "udp"
    from_port = 0
    to_port = 65535
    source_security_group_id = "${aws_security_group.spark-slave.id}"
}

# Web
resource "aws_security_group_rule" "spark-master-web" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8443
    to_port = 8443
    source_security_group_id = "${var.bastion_security_group_id}"
}

# SSH
resource "aws_security_group_rule" "spark-master-ssh" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 22
    to_port = 22
	source_security_group_id = "${var.bastion_security_group_id}"
}

#### Expose web interfaces to VPN

# Yarn
resource "aws_security_group_rule" "spark-master-ssh" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8088
    to_port = 8088
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Spark History
resource "aws_security_group_rule" "spark-master-spark-history" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 18080
    to_port = 18080
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Zeppelin
 resource "aws_security_group_rule" "spark-master-zeppelin" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8890
    to_port = 8890
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Spark UI
 resource "aws_security_group_rule" "spark-master-zeppelin" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    protocol = "tcp"
    from_port = 4040
    to_port = 4040
    source_security_group_id = "${var.bastion_security_group_id}"
}

# Ganglia
 resource "aws_security_group_rule" "spark-master-ganglia" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    source_security_group_id = "${var.bastion_security_group_id}"
  }

# Hue
 resource "aws_security_group_rule" "spark-master-hue" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "ingress"
    from_port   = 8888
    to_port     = 8888
    protocol    = "TCP"
    source_security_group_id = "${var.bastion_security_group_id}"
  }
  
  
/*  
  
## Egress
  
resource "aws_security_group_rule" "spark-master-egress" {
    security_group_id = "${aws_security_group.spark-master.id}"
    type = "egress"
    protocol = "-1"
    from_port = 0
    to_port = 0
	cidr_blocks = ["0.0.0.0/0"]
}

*/


