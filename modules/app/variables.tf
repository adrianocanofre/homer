variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "app_name" {
  description = "Application Name"
  default = "Homer"
}

variable "region" {
  description = "Region to create the infrastructure"
  default = "us-east-1"
}

###### Application ######
variable "all_cidr" {
  description = ""
  default = "0.0.0.0/0"
}

variable "http_port" {
  description = ""
  default = 80
}

variable "lb_type" {
  description = "The type of load balancer to create(application|network)"
  default = "application"
}

variable "http_protocol" {
  description = "Protocol HTTP"
  default ="HTTP"
}

variable "key_pair" {
  description = "The key name of the Key Pair to use for the instance"
  default = "terraform_aws"
}

variable "workspace" {
  default = ""
}

variable "user_data" {
  default = ""
}

variable "ec2_type"{
  default = "t2.micro"
}

variable "public_subnets" {
  default = ""
}

variable "private_subnets" {
  default = ""
}

variable "vpc" {
  default = ""
}

locals {
  lb_name  = format("%s-lb-%s",var.workspace, var.app_name)
  tg_name  = format("%s-tg-%s",var.workspace, var.app_name)
  asg_name = format("%s-asg-%s-",var.workspace, var.app_name)
  lc_name  = format("%s-lc%s",var.workspace, var.app_name)
  tags = {
    Environment = var.workspace
    Owner       = "terraform"
  }
}
