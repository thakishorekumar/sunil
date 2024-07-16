data "aws_db_instance" "primary_db" {
  provider               = aws.primary
  db_instance_identifier = "primary-db"

  depends_on = [aws_db_instance.primary_db]
}

resource "aws_db_subnet_group" "dr_db_subnet_group" {
  provider   = aws.secondary
  name       = "dr-db-subnet-group"
  subnet_ids = [aws_subnet.dr-prv-sub-1a.id, aws_subnet.dr-prv-sub-1b.id]

  tags = {
    Name = "dr-db-subnet-group"
  }
}


resource "aws_db_instance" "secondary_db" {
  provider               = aws.secondary
  identifier             = "secondary-db"
  instance_class         = "db.t3.micro"
  engine                 = "mysql"
  engine_version         = "8.0.35"
  skip_final_snapshot    = true
  replicate_source_db    = data.aws_db_instance.primary_db.db_instance_arn
  db_subnet_group_name   = aws_db_subnet_group.dr_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.dr-sg.id]
}

#   final_snapshot_identifier = "snapshot-identifier"
#username, password and allocated_storage will be inherited from primary-db
