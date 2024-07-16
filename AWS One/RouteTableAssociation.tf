resource "aws_route_table_association" "web-rta1" {
  provider       = aws.primary
  subnet_id      = aws_subnet.web-pub-sub-1a.id
  route_table_id = aws_route_table.web-rt.id

}

resource "aws_route_table_association" "web-rta2" {
  provider       = aws.primary
  subnet_id      = aws_subnet.web-pub-sub-1b.id
  route_table_id = aws_route_table.web-rt.id

}
