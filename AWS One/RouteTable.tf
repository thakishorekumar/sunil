resource "aws_route_table" "web-rt" {
  provider = aws.primary
  vpc_id   = aws_vpc.web-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web-igw.id
  }

  tags = {
    Name = "Terraform-RT"
  }
}
