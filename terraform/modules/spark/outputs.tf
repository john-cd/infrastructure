
//
// Outputs
//

/* TODO
output "spark-example-application" {
  value = <<SPARKEXAMPLE
spark-master-0-address = ${aws_instance.spark-master.0.public_ip}
spark-slave-0-address  = ${aws_instance.spark-slave.0.public_ip}
To view the Spark console, run the command below and then open http://localhost:8080/ in your browser.
    ssh -i credentials/<key>.pem -L 8080:${aws_instance.spark-master.0.private_ip}:8080 ubuntu@${aws_instance.spark-master.0.public_ip}
To run an example Spark application in your Spark cluster, run the command below.
    ssh -i credentials/<key>.pem ubuntu@${aws_instance.spark-master.0.public_ip} MASTER=spark://${element(split(".",aws_instance.spark-master.0.private_dns),0)}:7077 /opt/spark/default/bin/run-example SparkPi 10
SPARKEXAMPLE
}
*/