## aws-sg.tf
# Security Group
resource "aws_security_group" "alb" {
  name        = "sg_alb_${terraform.workspace}"
  description = "for ALB"
  vpc_id      = aws_vpc.vpc.id
}
 
resource "aws_security_group" "fargate" {
  name        = "sg_fargate_${terraform.workspace}"
  description = "for Fargate"
  vpc_id      = aws_vpc.vpc.id
}
 
resource "aws_security_group" "efs" {
  name        = "sg_efs_${terraform.workspace}"
  description = "for EFS"
  vpc_id      = aws_vpc.vpc.id
}
 
resource "aws_security_group" "rds" {
  name        = "sg_rds_${terraform.workspace}"
  description = "for RDS"
  vpc_id      = aws_vpc.vpc.id
}
 
# Security Group Rule
resource "aws_security_group_rule" "allow_http_for_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow_http_for_alb"
}
 
resource "aws_security_group_rule" "from_alb_to_fargate" {
  security_group_id        = aws_security_group.fargate.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.alb.id
  description              = "from ALB to Fargate"
}
 
resource "aws_security_group_rule" "from_fargate_to_efs" {
  security_group_id        = aws_security_group.efs.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 2049
  to_port                  = 2049
  source_security_group_id = aws_security_group.fargate.id
  description              = "from Fargate to EFS"
}
 
resource "aws_security_group_rule" "from_fargate_to_rds" {
  security_group_id        = aws_security_group.rds.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.fargate.id
  description              = "from Fargate to RDS"
}

resource "aws_security_group_rule" "eggress_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}
 
resource "aws_security_group_rule" "eggress_fargate" {
  security_group_id = aws_security_group.fargate.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}
 
resource "aws_security_group_rule" "eggress_efs" {
  security_group_id = aws_security_group.efs.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}
 
resource "aws_security_group_rule" "eggress_rds" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}

