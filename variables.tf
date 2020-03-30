variable "vpc_name" {
  type    = string
  default = "vpc-dev"
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/20"
}

variable "cidr_public_subnet" {
  type    = list
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "azs" {
  type    = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
