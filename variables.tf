variable "aws_region" {
  description = "AWS region used by the lab."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used for resource names."
  type        = string
  default     = "microservices"
}

variable "vpc_cidr" {
  description = "CIDR of the lab VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "container_port" {
  description = "Port exposed by the NestJS container."
  type        = number
  default     = 3000
}

variable "task_cpu" {
  description = "Task CPU units. 256 = 0.25 vCPU."
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Task memory in MiB. 512 = 0.5 GB."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of Tasks maintained by the ECS Service."
  type        = number
  default     = 1
}

variable "ec2_instance_type" {
  description = "EC2 instance type used as ECS capacity."
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr" {
  description = "CIDR allowed to SSH to the ECS EC2 instance. Use YOUR_PUBLIC_IP/32."
  type        = string
  default     = "0.0.0.0/0"
}

variable "image_tag" {
  description = "ECR image tag used by the Task Definition."
  type        = string
  default     = "latest"
}
