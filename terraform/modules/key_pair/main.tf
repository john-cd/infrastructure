resource "aws_key_pair" "main_ec2_key" {
  key_name   = "${var.key_name}"
  public_key = "${file(format("%s/%s", path.root, var.public_key_path))}"
}
