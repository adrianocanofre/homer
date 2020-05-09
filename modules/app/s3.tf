resource "aws_s3_bucket" "user_data" {
  bucket_prefix = format("%s-userdata-", var.app_name)
  acl           = "private"
  force_destroy = true
  region        = var.region

  versioning {
    enabled = var.version_enable
  }

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


# resource "aws_s3_bucket" "this" {
#   count = var.create_bucket ? 1 : 0
#   bucket_prefix = var.app_name
#   acl    = "private"
#   force_destroy = true
#   region = var.region
#
#   versioning {
#     enabled = var.version_enable
#   }
#
#   tags = {
#     Name        = "My bucket"
#     Environment = "Dev"
#   }
# }
