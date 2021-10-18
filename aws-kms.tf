## aws-kms.tf
# 
resource "aws_kms_key" "kms_key" {
  description             = "CMK for ${terraform.workspace}"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
}

resource "aws_kms_alias" "kms_alias" {
  name          = "alias/${terraform.workspace}_key"
  target_key_id = aws_kms_key.kms_key.key_id
}
