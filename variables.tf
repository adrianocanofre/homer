variable "vpc_name" {
  type    = string
  default = "vpc"
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/20"
}

variable "cidr_public_subnet" {
  type    = list
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "cidr_private_subnet" {
  type    = list
  default = ["10.0.4.0/22", "10.0.8.0/22", "10.0.12.0/22"]
}

variable "azs" {
  type    = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "envs" {
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

variable "all_cidr" {
  default = "0.0.0.0/0"
}

variable "http_port" {
  default = 80
}


variable "lb_type" {
  default = "application"
}


variable "http_protocol" {
  default ="HTTP"
}

variable "region" {
  default = "us-east-1"
}


variable "key_par" {
  default = "terraform_aws"
}
