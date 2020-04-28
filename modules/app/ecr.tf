resource "aws_ecr_repository" "this" {
  name                 = var.app_name
  image_tag_mutability = var.image_mutability
  tags                 = merge(var.tags, local.tags)

  image_scanning_configuration {
    scan_on_push = true
  }
}
