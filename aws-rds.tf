## aws-rds.tf
# parameter group
resource "aws_db_parameter_group" "pg-rds" {
  name        = "pg-rds-${terraform.workspace}"
  family      = var.rds.family
  description = "Prameter Group for ${terraform.workspace}"
}
 
# db subnet group
resource "aws_db_subnet_group" "dbsg-rds" {
  name        = "dbsg-${terraform.workspace}"
  description = "DB Subnet Group for ${terraform.workspace}"
  subnet_ids = [
    aws_subnet.db_1c.id,
    aws_subnet.db_1d.id
  ]
}
# rds
resource "aws_db_instance" "rds" {
  identifier                = "rds-${terraform.workspace}"
  engine                    = var.rds.engine
  engine_version            = var.rds.version
  instance_class            = var.rds.class
  storage_type              = "gp2"
  allocated_storage         = var.rds.dbgsize
  max_allocated_storage     = "3000"
  username                  = var.rds.username
  password                  = var.rds.password
  final_snapshot_identifier = "rds-final-${terraform.workspace}"
  db_subnet_group_name      = aws_db_subnet_group.dbsg-rds.name
  parameter_group_name      = aws_db_parameter_group.pg-rds.name
  multi_az                  = false
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]
  backup_retention_period = var.rds.bkperiod
  apply_immediately       = true
}
