resource "aws_iam_role" "app_role" {
  name               = format("%s-instance_role", var.workspace)
  assume_role_policy = data.aws_iam_policy_document.app_policy.json
}

resource "aws_iam_instance_profile" "app_profile" {
  name = format("%s-app_profile", var.workspace)
  role = aws_iam_role.app_role.name
}

resource "aws_iam_role_policy" "app_policy" {
  name = format("%s-app_policy", var.workspace)
  role = aws_iam_role.app_role.id

  policy = data.aws_iam_policy_document.ec2_ecr.json
}
