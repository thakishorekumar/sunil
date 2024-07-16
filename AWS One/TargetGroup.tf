resource "aws_lb_target_group" "web-tg" {
  provider    = aws.primary
  name        = "Terraform-LB-TG"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.web-vpc.id
}

