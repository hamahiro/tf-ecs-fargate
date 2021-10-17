## alb 
resource "aws_alb" "alb" {
  name            = "alb-${terraform.workspace}"
  security_groups = [aws_security_group.alb.id]

  subnets = [
    aws_subnet.public_1c.id,
    aws_subnet.public_1d.id,
  ]

  internal                   = false
}

# target group
resource "aws_alb_target_group" "tg-alb" {
  name        = "tg-alb-${terraform.workspace}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path = "/"
  }
}

# listner
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.tg-alb.arn
    type             = "forward"
  }
}
