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

resource "aws_subnet" "public_1" {

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags ={
      "Name" = format("%s-pub-1", var.name)
    }
}

resource "aws_subnet" "public_2" {

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags ={
      "Name" = format("%s-pub-2", var.name)
    }
}

resource "aws_subnet" "public_3" {

  vpc_id                          = aws_vpc.this.id
  cidr_block                      = "10.0.3.0/24"
  map_public_ip_on_launch = true
  tags ={
      "Name" = format("%s-pub-3", var.name)
    }
}
