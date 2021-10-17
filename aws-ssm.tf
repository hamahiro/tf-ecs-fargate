## aws-ssm.tf
resource "aws_ssm_parameter" "db_host" {
  name        = "DB_HOST"
  description = "DB_HOST"
  type        = "String"
  value       = aws_db_instance.rds.address
}
 
resource "aws_ssm_parameter" "db_user" {
  name        = "DB_USER"
  description = "DB_USER"
  type        = "String"
  value       = "wordpress"
}
 
resource "aws_ssm_parameter" "db_password" {
  name        = "DB_PASSWORD"
  description = "DB_PASSWORD"
  type        = "String"
  value       = "wordpress-db-passw0rd!"
}
 
resource "aws_ssm_parameter" "db_name" {
  name        = "DB_NAME"
  description = "DB_NAME"
  type        = "String"
  value       = "wordpress"
}
