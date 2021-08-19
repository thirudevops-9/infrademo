resource "aws_lb" "devapi" {
  name                       = "devapi-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb.id]
  subnets                    = ["${aws_subnet.public[0].id}", "${aws_subnet.public[1].id}", "${aws_subnet.public[2].id}"]
  enable_deletion_protection = false


  tags = {
    Environment = "api-alb"
  }
}

# instance target group

resource "aws_lb_target_group" "devapi" {
  name     = "devapilb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id
}



resource "aws_lb_target_group_attachment" "devapi" {
  target_group_arn = aws_lb_target_group.devapi.arn
  target_id        = aws_instance.devapi.id
  port             = 8080
}


# listner


resource "aws_lb_listener" "back_end" {
  load_balancer_arn = aws_lb.devapi.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.devapi.arn
  }
}
