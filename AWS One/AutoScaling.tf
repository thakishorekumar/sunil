resource "aws_autoscaling_group" "web-asg" {
  provider = aws.primary
  name     = "Terraform-ASG"
  #availability_zones = ["ap-south-1a", "ap-south-1b"]
  desired_capacity = 2
  max_size         = 3
  min_size         = 2

  launch_template {
    id      = aws_launch_template.web-template.id
    version = "$Latest"
  }
  target_group_arns         = [aws_lb_target_group.web-tg.arn]
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = true
  vpc_zone_identifier       = [aws_subnet.web-pub-sub-1a.id, aws_subnet.web-pub-sub-1b.id]
}
