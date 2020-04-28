data "aws_iam_policy_document" "app_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "app_role" {
  name               = "instance_role"
  assume_role_policy = data.aws_iam_policy_document.app_policy.json
}

resource "aws_iam_instance_profile" "app_profile" {
  name = "app_profile"
  role = aws_iam_role.app_role.name
}

resource "aws_iam_role_policy" "app_policy" {
  name = "app_policy"
  role = aws_iam_role.app_role.id

  policy = data.aws_iam_policy_document.ec2_ecr.json
}
