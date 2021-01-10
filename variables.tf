###### Common ######
variable "envs" {
  description = "Define a workspace"
  type        = map
  default = {
    dev  = "dev"
    prod = "prod"
  }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "Application Name"
  default     = "Homer"
}

variable "region" {
  description = "Region to create the infrastructure"
  default     = "us-east-1"
}

locals {
  env = lookup(var.envs, terraform.workspace)
  tags = {
    Environment = local.env
    Owner       = "terraform"
  }
}
