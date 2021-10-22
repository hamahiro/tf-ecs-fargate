## aws-iam.tf
# iam role
resource "aws_iam_role" "fargate_task_execution" {
  name               = "role-fargate_task_execution-${terraform.workspace}"
  assume_role_policy = file("./roles/fargate_task_assume_role.json")
}

# attach AmazonECSTaskExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "execution_attach" {
  role       = aws_iam_role.fargate_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}