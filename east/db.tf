data "aws_vpc" "default" {}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
  tags = {
    tier = "db"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [data.aws_subnet_ids.*.id]
}

resource "aws_db_instance" "default" {
  identifier           = mydatabase
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "foo"
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.default.name
}

resource "aws_db_parameter_group" "default" {
  name        = "default.mysql5.7"
  family      = mysql5.7
  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}
