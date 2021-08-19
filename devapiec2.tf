resource "aws_security_group" "devapi" {
  name        = "devapi"
  description = "Allow tomcat inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description     = "devapi from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-api-sg"
  }
}



#ec2
resource "aws_instance" "devapi" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.dev.id
  subnet_id              = aws_subnet.private[0].id
  vpc_security_group_ids = ["${aws_security_group.devapi.id}"]
  tags = {
    Name = "${var.envname}-api"
  }
}