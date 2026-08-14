output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "ecr_repository_url" {
  value = aws_ecr_repository.health.repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "health_url" {
  value = "http://${aws_lb.main.dns_name}/health"
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2.id
}

output "task_security_group_id" {
  value = aws_security_group.task.id
}
