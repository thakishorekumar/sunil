resource "aws_internet_gateway" "web-igw" {
  provider = aws.primary
  vpc_id   = aws_vpc.web-vpc.id

  tags = {
    Name = "Terraform-IGW"
  }
}
