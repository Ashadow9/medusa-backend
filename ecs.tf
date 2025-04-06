### Step 5: Create ECR Repository

resource "aws_ecr_repository" "medusa" {
  name = "medusa-server"
  image_scanning_configuration { scan_on_push = true }
}


### Step 6: ECS Cluster + Task + Service
resource "aws_ecs_cluster" "medusa" {
  name = "medusa-cluster"
}

resource "aws_ecs_task_definition" "medusa" {
  family                   = "medusa-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  container_definitions = jsonencode([{
    name      = "medusa"
    image     = "${aws_ecr_repository.medusa.repository_url}:latest"
    essential = true
    portMappings = [{ containerPort = 9000, hostPort = 9000 }]
  }])
}

resource "aws_ecs_service" "medusa" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa.id
  task_definition = aws_ecs_task_definition.medusa.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.public_a.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }
  depends_on = [aws_iam_role_policy_attachment.ecs_policy]
}
