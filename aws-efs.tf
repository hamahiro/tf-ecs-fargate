## aws-efs.tf
resource "aws_efs_file_system" "efs" {
  creation_token                  = "fargate-efs"
  throughput_mode                 = "bursting"
  encrypted                       = "true"

  tags = {
    Name = "fargate-efs-${terraform.workspace}"
  }
}

# mount target
resource "aws_efs_mount_target" "db_1c" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.db_1c.id
  security_groups = [
    aws_security_group.efs.id
  ]
}

resource "aws_efs_mount_target" "db_1d" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.db_1d.id
  security_groups = [
    aws_security_group.efs.id
  ]
}

