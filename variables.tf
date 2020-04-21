###### Common ######
variable "envs" {
  description = "Define a workspace"
  type = map
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
  default = "Homer"
}

variable "region" {
  description = "Region to create the infrastructure"
  default = "us-east-1"
}

###### VPC ######
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
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "cidr_private_subnet" {
  description = "The cidr block of the desired subnet"
  type    = list
  default = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22"]
}

variable "azs" {
  description = "The az for the subnets"
  type    = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
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
