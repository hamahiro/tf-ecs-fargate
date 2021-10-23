## aws-fargate.tf
# cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-${terraform.workspace}"
}
setting {
  name = "containerInsights"
  value = "disabled"
}

# task definition
resource "aws_ecs_task_definition" "task" {
  family                = "ecs-task-${terraform.workspace}"
  container_definitions = file("tasks/container_definitions.json")
  cpu                   = var.ecs_task.cpu
  memory                = var.ecs_task.memory
  network_mode          = awsvpc
  execution_role_arn    = aws_iam_role.fargate_task_execution.arn

  volume {
    name = "fargate-efs"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.efs.id
      root_directory = "/"
    }
  }
  requirequires_compatibilities = [
    "FARGATE"
  ] 
}

# service
resource "aws_ecs_service" "service" {
  name = "ecs-service-${terraform.workspace}"
  cluster = aws_ecs_cluster.ecs_cluster.arn
  task_definition = aws_ecs_task_definition.task.arn
  desired_count = 2
  launch_type = "FARGATE"
  platform_version = "1.4.0"

  load_balancer {
    target_group_arn = aws_lb_target_group.tg-alb.arn
    container_name = "wordpress-{terraform.workspace}"
    container_port = "80"
  }

  network_configuration {
    subnets = [
      aws_subnet.private_1c.id,
      aws_subnet.private_1d.id
    ]
    security_groups = [
      aws_security_group.fargate.id
    ]
    assign_public_ip = false
  }
  
}
