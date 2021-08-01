locals {
  app_name  = format("%s-%s", var.app_name, var.workspace)
  tags = {
    environment = var.workspace
    create_by   = "terraform"
  }
}
