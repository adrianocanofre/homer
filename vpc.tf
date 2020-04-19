resource "aws_vpc" "this" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  tags ={
      "Name" = format("%s", local.vpc_name)
    }
}

resource "aws_subnet" "public" {
  count                   = length(var.cidr_public_subnet)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.cidr_public_subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags ={
      "Name" = format("%s-pub-%d", local.vpc_name, count.index+1)
    }
}

resource "aws_subnet" "private" {
  count                   = length(var.cidr_private_subnet)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.cidr_private_subnet, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags ={
      "Name" = format("%s-priv-%d", local.vpc_name, count.index+1)
    }
}


resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
      "Name" = format("%s", local.vpc_name)
    }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
      "Name" = format("%s-pub-rt", local.vpc_name)
    }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.all_cidr
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

resource "aws_route_table" "private" {

  vpc_id = aws_vpc.this.id

  tags = {
      "Name" = format("%s-prvt-rt", local.vpc_name)
    }
}

resource "aws_route_table_association" "private" {
  count = length(var.cidr_private_subnet)

  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.all_cidr
  nat_gateway_id         = aws_nat_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_eip" "this" {
  vpc = true
}

resource "aws_nat_gateway" "this" {

  allocation_id = aws_eip.this.id
  subnet_id = aws_subnet.public.0.id


  depends_on = [aws_internet_gateway.this]
}
