resource "aws_vpc" "web-vpc" {
  provider   = aws.primary
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Terraform-VPC"
  }
}
