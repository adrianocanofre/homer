resource "aws_instance" "nginx" {
	ami = "ami-07ebfd5b3428b6f4d"
	instance_type = "t2.nano"
	key_name = var.key_par
	user_data = file("files/install_nginx.sh")
	subnet_id = aws_subnet.private[1].id
  vpc_security_group_ids = [aws_security_group.ec2.id]
}
