provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "aws-terraform"
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags ={
      "Name" = format("%s", var.name)
    }
}

resource "aws_subnet" "public" {
  count            = length(var.cidr_public_subnet)
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = element(var.cidr_public_subnet, count.index)
  map_public_ip_on_launch = true
  tags ={
      "Name" = format("%s-pub-%d", var.name, count.index+1)
    }
}
