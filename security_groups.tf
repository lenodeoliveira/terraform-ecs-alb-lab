# Traffic path:
#   Internet --TCP 80--> ALB SG --TCP 3000--> Task SG --> NestJS
# SSH to the ECS host is controlled by var.ssh_cidr.

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for the Application Load Balancer"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "HTTP from Internet"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-alb-sg"
  }
}

resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-ec2-sg"
  description = "Security group for the ECS EC2 instance"
  vpc_id      = module.network.vpc_id

  ingress {
    description = "SSH for lab administration"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.ssh_cidr]
  }

  egress {
    description = "Allow outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }
}

resource "aws_security_group" "task" {
  name        = "${var.project_name}-task-sg"
  description = "Security group for ECS task ENIs"
  vpc_id      = module.network.vpc_id

  ingress {
    description     = "HTTP from the ALB"
    protocol        = "tcp"
    from_port       = var.container_port
    to_port         = var.container_port
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-task-sg"
  }
}
