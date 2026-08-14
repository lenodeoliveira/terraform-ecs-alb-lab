# Root composes reusable modules with lab-specific wiring (SG, IAM, ALB, ECR).

module "network" {
  source = "./modules/network"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
}

module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  aws_region   = var.aws_region

  subnet_ids             = module.network.public_subnet_ids
  ec2_security_group_id  = aws_security_group.ec2.id
  task_security_group_id = aws_security_group.task.id

  instance_profile_name = aws_iam_instance_profile.ecs_instance.name
  execution_role_arn    = aws_iam_role.task_execution.arn
  task_role_arn         = aws_iam_role.task.arn

  container_image   = aws_ecr_repository.health.repository_url
  image_tag         = var.image_tag
  container_port    = var.container_port
  task_cpu          = var.task_cpu
  task_memory       = var.task_memory
  desired_count     = var.desired_count
  ec2_instance_type = var.ec2_instance_type

  target_group_arn = aws_lb_target_group.health.arn

  # Ensure the execution policy and ALB listener exist before the service starts.
  depends_on = [
    aws_iam_role_policy_attachment.task_execution,
    aws_lb_listener.http,
  ]
}
