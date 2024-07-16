resource "aws_db_subnet_group" "primary_db_subnet_group" {
  provider   = aws.primary
  name       = "primary-db-subnet-group"
  subnet_ids = [aws_subnet.web-prv-sub-1a.id, aws_subnet.web-prv-sub-1b.id]

  tags = {
    Name = "primary-db-subnet-group"
  }
}

resource "aws_db_instance" "primary_db" {
  provider               = aws.primary
  identifier             = "primary-db"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.35"
  username               = "admin"
  password               = "Manager(4242)"
  db_subnet_group_name   = aws_db_subnet_group.primary_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  skip_final_snapshot    = true
  #snapshot_identifier    = "terraform-db-snapshot"
}




