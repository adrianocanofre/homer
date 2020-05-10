resource "aws_s3_bucket" "user_data" {
  bucket_prefix = format("%s-userdata-", var.bucket_name_env)
  acl           = "private"
  force_destroy = true
  region        = var.region

  versioning {
    enabled = var.version_enable
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = merge(var.tags, local.tags)
}

# resource "aws_s3_bucket_object" "s3_folder" {
#     bucket   = aws_s3_bucket.user_data.id
#     acl      = "private"
#     key      =  "environment/"
# }


# resource "aws_s3_bucket" "this" {
#   count = var.create_bucket ? 1 : 0
#   bucket_prefix = local.bucket_name
#   acl           = "private"
#   force_destroy = true
#   region        = var.region
#
#   versioning {
#     enabled = var.version_enable
#   }
#
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }
#
#   tags = merge(var.tags, local.tags)
# }
