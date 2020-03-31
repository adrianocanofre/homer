provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "aws-terraform"
}

resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags ={
      "Name" = format("%s", var.vpc_name)
    }
}

resource "aws_subnet" "public" {
  count                   = length(var.cidr_public_subnet)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.cidr_public_subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags ={
      "Name" = format("%s-pub-%d", var.vpc_name, count.index+1)
    }
}

resource "aws_subnet" "private" {
  count                   = length(var.cidr_private_subnet)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.cidr_private_subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags ={
      "Name" = format("%s-pub-%d", var.vpc_name, count.index+1)
    }
}
