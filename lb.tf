resource "aws_lb" "this" {

  name        = "teste"

  load_balancer_type = "application"
  internal           = false
  subnets            = aws_subnet.private.*.id



}
