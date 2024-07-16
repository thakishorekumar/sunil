resource "aws_security_group" "dr-sg" {
  provider    = aws.secondary
  name        = "DR-Terraform-SG"
  description = "Terraform http & RDP allow"
  vpc_id      = aws_vpc.dr-vpc.id

  tags = {
    Name = "DR-Terraform-SG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "dr_http_allow_all" {
  provider          = aws.secondary
  security_group_id = aws_security_group.dr-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "dr_rdp_allow_ip" {
  provider          = aws.secondary
  security_group_id = aws_security_group.dr-sg.id
  cidr_ipv4         = "103.163.248.19/32"
  from_port         = 3389
  ip_protocol       = "tcp"
  to_port           = 3389
}

resource "aws_vpc_security_group_ingress_rule" "rds2_allow_ip" {
  provider          = aws.secondary
  security_group_id = aws_security_group.dr-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "dr_allow_all_egress" {
  provider          = aws.secondary
  security_group_id = aws_security_group.dr-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
