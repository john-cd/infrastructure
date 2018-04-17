
# Create a role
# First a service role is necessary. This role defines what the cluster is allowed to do within the EMR environment.
# See https://intothedepthsofdataengineering.wordpress.com/2017/11/19/terraforming-a-spark-cluster-on-amazon/

resource "aws_iam_role" "spark_cluster_service_role" {
    name = "${var.application_name}-${var.environment_name}-spark-cluster-service-role"
 
    assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "elasticmapreduce.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# This service role needs a policy attached. We will simply use the default EMR role.

resource "aws_iam_role_policy_attachment" "spark_cluster_service_role_policy_attach" {
   role = "${aws_iam_role.spark_cluster_service_role.id}"
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"
}

# Next we need a role for the EMR profile --------------------------------------------

resource "aws_iam_role" "spark_cluster_profile_role" {
    name = "${var.application_name}-${var.environment_name}-spark-cluster-profile-role"
    assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

# This role is assigned the EC2 default role, which defines what the cluster is allowed to do in the EC2 environment.

resource "aws_iam_role_policy_attachment" "spark_cluster_profile_role_policy_attach" {
   role = "${aws_iam_role.spark_cluster_profile_role.id}"
   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"
}

# Lastly the instance profile, which is used to pass the role’s details to the EC2 instances.

resource "aws_iam_instance_profile" "spark_cluster_instance_profile" {
   name = "${var.application_name}-${var.environment_name}-spark-cluster-instance-profile"
   role = "${aws_iam_role.spark_cluster_profile_role.name}"
}