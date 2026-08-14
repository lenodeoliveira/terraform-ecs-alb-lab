variable "project_name" {
  description = "Prefix used for resource names."
  type        = string
}

variable "aws_region" {
  description = "AWS region (CloudWatch log options)."
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for the ASG and ECS service ENIs."
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "Security group attached to the ECS EC2 instances."
  type        = string
}

variable "task_security_group_id" {
  description = "Security group attached to ECS task ENIs."
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile for the ECS EC2 host."
  type        = string
}

variable "execution_role_arn" {
  description = "IAM role ARN used by the ECS agent (ECR pull, logs)."
  type        = string
}

variable "task_role_arn" {
  description = "IAM role ARN assumed by the running container."
  type        = string
}

variable "container_image" {
  description = "ECR repository URL without tag."
  type        = string
}

variable "image_tag" {
  description = "Image tag to deploy."
  type        = string
}

variable "container_port" {
  description = "Port exposed by the container."
  type        = number
}

variable "task_cpu" {
  description = "Task CPU units."
  type        = number
}

variable "task_memory" {
  description = "Task memory in MiB."
  type        = number
}

variable "desired_count" {
  description = "Desired number of tasks."
  type        = number
}

variable "ec2_instance_type" {
  description = "EC2 instance type for ECS capacity."
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for the health service."
  type        = string
}
