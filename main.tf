provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "aws-terraform"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "homer-s3-state"

  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-state-lock-dynamo-homer"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
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


resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
      "Name" = format("%s", var.vpc_name)
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
      "Name" = format("%s-pub-rt", var.vpc_name)
    }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.cidr_public_subnet)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}
