resource "aws_lb" "web-alb" {
  provider           = aws.primary
  name               = "Terraform-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web-sg.id]
  subnets            = [aws_subnet.web-pub-sub-1a.id, aws_subnet.web-pub-sub-1b.id]
  #subnets            = [for subnet in aws_subnet.web-pub-sub : subnet.id]

  #enable_deletion_protection = false

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    Environment = "Terraform-ALB"
  }
}

resource "aws_lb_listener" "web-alb-list" {
  provider          = aws.primary
  load_balancer_arn = aws_lb.web-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web-tg.arn
  }
}
