variable "vpc_name" {
  description = "Name of VPC"
  type    = string
  default = "vpc"
}

variable "cidr" {
  description = "The cidr block of the desired VPC"
  type    = string
  default = "10.0.0.0/20"
}

variable "cidr_public_subnet" {
  description = "The cidr block of the desired subnet."
  type    = list
  default = [""]
}

variable "cidr_private_subnet" {
  description = "The cidr block of the desired subnet"
  type    = list
  default = [""]
}

variable "azs" {
  description = "The az for the subnets"
  type    = list
  default = [""]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "workspace" {
  default = ""
}

variable "all_cidr" {
  default = "0.0.0.0/0"
}

locals {
  tags = {
    Environment = var.workspace
    Owner       = "terraform"
  }
}
