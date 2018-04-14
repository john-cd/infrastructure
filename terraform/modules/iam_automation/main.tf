# Create automation group

resource "aws_iam_group" "automation_group" {
  name = "automation_group"

  #  path = "/users/"
}

data "aws_iam_policy" "sysadmin_policy" {
  arn = "arn:aws:iam::aws:policy/job-function/SystemAdministrator"
}

resource "aws_iam_group_policy_attachment" "automation_group_attach" {
  group      = "${aws_iam_group.automation_group.name}"
  policy_arn = "${data.aws_iam_policy.sysadmin_policy.arn}"
}

# Create automation user

resource "aws_iam_user" "automation_user" {
  name          = "automation_user"
  force_destroy = true
}

resource "aws_iam_group_membership" "automation_group_membership" {
  name = "automation_group_membership"

  users = [
    "${aws_iam_user.automation_user.name}",
  ]

  group = "${aws_iam_group.automation_group.name}"
}

resource "aws_iam_access_key" "automation_user_access_key" {
  user = "${aws_iam_user.automation_user.name}"
}
