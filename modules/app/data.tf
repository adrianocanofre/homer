data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-????.??.?.????????-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}


data "aws_iam_policy_document" "ec2_app" {
  statement {

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken",
    ]

    resources = [
       "*"
    ]
  }

  statement {

    actions = [
      "s3:ListAllMyBuckets"
    ]

    resources = [
      "arn:aws:s3:::*",
    ]
  }

  statement {

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.user_data.arn,
    ]
  }

  statement {

    actions = [
      "s3:GetObject",
      "s3:GetObjectAcl"
    ]

    resources = [
      format("%s/*",aws_s3_bucket.user_data.arn)
    ]
  }
}

data "aws_iam_policy_document" "app_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
