 

provider "aws" {
  region = "ap-south-1"
}

# Reference outputs or use resources defined in other files here if needed.
# No need to redefine aws_ecs_cluster, aws_iam_role, etc.

# Example: If you want to output ECS service or cluster details
output "ecs_cluster_name" {
  value = aws_ecs_cluster.medusa.name
}

output "ecs_service_name" {
  value = aws_ecs_service.medusa.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.medusa.arn
}
