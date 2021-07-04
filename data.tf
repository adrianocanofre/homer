data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "selected" {
  tags = {
    Name        = "homer-dev"
    environment = "dev"
  }
}


data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name        = "homer-public-dev"
    environment = "dev"
  }
}


data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.selected.id

  tags = {
    Name        = "homer-private-dev"
    environment = "dev"
  }
}
