resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_type
  key_name      = var.key_name
  tags = {
    Name = "teste-homer"
  }
}

resource "aws_lb" "this" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  subnets            = data.aws_subnet_ids.default.ids

}

resource "aws_lb_listener" "this" {

  load_balancer_arn = aws_lb.this.arn
  port              = var.lb_port
  protocol          = var.lb_protocol

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      message_body = "{'home': 'teste'}"
      status_code  = "200"
    }
  }
}
