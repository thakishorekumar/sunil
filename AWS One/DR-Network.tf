resource "aws_vpc" "dr-vpc" {
  provider   = aws.secondary
  cidr_block = "11.0.0.0/16"

  tags = {
    Name = "DR-Terraform-VPC"
  }
}

resource "aws_internet_gateway" "dr-igw" {
  provider = aws.secondary
  vpc_id   = aws_vpc.dr-vpc.id

  tags = {
    Name = "DR-Terraform-IGW"
  }
}

resource "aws_subnet" "dr-pub-sub-1a" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.dr-vpc.id
  cidr_block              = "11.0.1.0/24"
  availability_zone       = "ap-south-2a"
  map_public_ip_on_launch = true

  depends_on = [aws_internet_gateway.dr-igw]

  tags = {
    Name = "DR-Terraform-Public-1-Subnet"
  }
}

resource "aws_subnet" "dr-prv-sub-1a" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.dr-vpc.id
  cidr_block        = "11.0.2.0/24"
  availability_zone = "ap-south-2a"

  depends_on = [aws_internet_gateway.dr-igw]

  tags = {
    Name = "DR-Terraform-Private-1-Subnet"
  }
}

resource "aws_subnet" "dr-prv-sub-1b" {
  provider          = aws.secondary
  vpc_id            = aws_vpc.dr-vpc.id
  cidr_block        = "11.0.3.0/24"
  availability_zone = "ap-south-2b"

  depends_on = [aws_internet_gateway.dr-igw]

  tags = {
    Name = "DR-Terraform-Private-2-Subnet"
  }
}

resource "aws_route_table" "dr-rt" {
  provider = aws.secondary
  vpc_id   = aws_vpc.dr-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dr-igw.id
  }

  tags = {
    Name = "DR-Terraform-RT"
  }
}

resource "aws_route_table_association" "dr-rta1" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.dr-pub-sub-1a.id
  route_table_id = aws_route_table.dr-rt.id

}
