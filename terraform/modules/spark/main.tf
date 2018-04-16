
## Create a EMR Cluster running Spark
# https://intothedepthsofdataengineering.wordpress.com/2017/11/19/terraforming-a-spark-cluster-on-amazon/


# TODO

## Create a EMR instance group
## https://www.terraform.io/docs/providers/aws/r/emr_instance_group.html

resource "aws_emr_instance_group" "instance_group" {
  cluster_id     = "${aws_emr_cluster.tf-test-cluster.id}"
  instance_count = 1
  instance_type  = "m3.xlarge"
  name           = "my little instance group"
}

# Create EMR security config
# https://www.terraform.io/docs/providers/aws/r/emr_security_configuration.html

resource "aws_emr_security_configuration" "foo" {
  name = "emrsc_other"

  configuration = <<EOF
{
  "EncryptionConfiguration": {
    "AtRestEncryptionConfiguration": {
      "S3EncryptionConfiguration": {
        "EncryptionMode": "SSE-S3"
      },
      "LocalDiskEncryptionConfiguration": {
        "EncryptionKeyProviderType": "AwsKms",
        "AwsKmsKey": "arn:aws:kms:us-west-2:187416307283:alias/tf_emr_test_key"
      }
    },
    "EnableInTransitEncryption": false,
    "EnableAtRestEncryption": true
  }
}
EOF
}

# Create a Spark cluster on AWS EMR
# https://www.terraform.io/docs/providers/aws/r/emr_cluster.html

resource "aws_emr_cluster" "emr-test-cluster" {
  name          = "emr-cluster"
  release_label = "emr-5.13.0"
  applications  = ["Spark"]  #or ["Ganglia", "Spark", "Zeppelin", "Hive", "Hue"]

  termination_protection = false
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                         = "${var.main_subnet_id}"
    emr_managed_master_security_group = "${aws_security_group.spark-master.id}"
    emr_managed_slave_security_group  = "${aws_security_group.spark-slave.id}"
    instance_profile                  = "${aws_iam_instance_profile.emr_profile.arn}"
	key_name = "${aws_key_pair.emr_key_pair.key_name}"
  }

  instance_group {
      instance_role = "CORE"
      instance_type = "c4.large"
      instance_count = "1"
      ebs_config {
        size = "40"
        type = "gp2"
        volumes_per_instance = 1
      }
      bid_price = "0.30"
      autoscaling_policy = <<EOF
{
"Constraints": {
  "MinCapacity": 1,
  "MaxCapacity": 2
},
"Rules": [
  {
    "Name": "ScaleOutMemoryPercentage",
    "Description": "Scale out if YARNMemoryAvailablePercentage is less than 15",
    "Action": {
      "SimpleScalingPolicyConfiguration": {
        "AdjustmentType": "CHANGE_IN_CAPACITY",
        "ScalingAdjustment": 1,
        "CoolDown": 300
      }
    },
    "Trigger": {
      "CloudWatchAlarmDefinition": {
        "ComparisonOperator": "LESS_THAN",
        "EvaluationPeriods": 1,
        "MetricName": "YARNMemoryAvailablePercentage",
        "Namespace": "AWS/ElasticMapReduce",
        "Period": 300,
        "Statistic": "AVERAGE",
        "Threshold": 15.0,
        "Unit": "PERCENT"
      }
    }
  }
]
}
EOF
}
  ebs_root_volume_size     = 100

  master_instance_type = "m3.xlarge"
  core_instance_type   = "m2.xlarge"
  core_instance_count  = 1

  tags {
    name = "EMR-cluster"
    role     = "rolename"
    env      = "${var.environment_name}"
  }

  bootstrap_action {
    path = "s3://elasticmapreduce/bootstrap-actions/run-if"
    name = "runif"
    args = ["instance.isMaster=true", "echo running on master node"]
  }

  # log_uri = "${aws_s3_bucket.logging_bucket.uri}"
  
  
  #configurations = "test-fixtures/emr_configurations.json"

  service_role = "${aws_iam_role.iam_emr_service_role.arn}"
}