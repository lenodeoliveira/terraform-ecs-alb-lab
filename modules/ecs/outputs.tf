output "cluster_id" {
  description = "ECS cluster ID."
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "ECS cluster name."
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.health.name
}

output "capacity_provider_name" {
  description = "ECS capacity provider name."
  value       = aws_ecs_capacity_provider.ec2.name
}
