#-----------------------------------------------------------------------------------------
# Security group
#-----------------------------------------------------------------------------------------

resource "aws_security_group" "db_server_sg" {
  name        = "db_server"
  description = "Allow http and https traffic."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "inbound_http" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_server_sg.id
}

#-----------------------------------------------------------------------------------------
# RDS
#-----------------------------------------------------------------------------------------
resource "aws_db_subnet_group" "rds-subnet-group" {
  name        = "test"
  description = "rds subnet group"
  subnet_ids  = [var.pri_subnets[0], var.pri_subnets[1]]
}

resource "aws_db_instance" "rds" {
  count                  = 1
  allocated_storage      = 10
  max_allocated_storage  = 20
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "mydb${count.index}"
  username               = var.db_user
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  availability_zone      = var.azs[count.index]
  db_subnet_group_name   = aws_db_subnet_group.rds-subnet-group.name
  vpc_security_group_ids = [aws_security_group.db_server_sg.id]
  tags = {
    Name = "${var.name}-rds-${count.index + 1}"
  }
}
