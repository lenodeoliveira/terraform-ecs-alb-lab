# ECS on EC2:
#   Cluster → Capacity Provider → ASG → Launch Template → Task → Service

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "${var.project_name}-ecs-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = var.ec2_instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config

    echo "ECS_ENABLE_TASK_IAM_ROLE=true" >> /etc/ecs/ecs.config

    echo "ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true" >> /etc/ecs/ecs.config
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-ecs-instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs" {
  name = "${var.project_name}-ecs-asg"

  min_size         = 1
  max_size         = 1
  desired_capacity = 1

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-ecs-instance"
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "ec2" {
  name = "${var.project_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [
    aws_ecs_capacity_provider.ec2.name
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2.name
    weight            = 1
    base              = 1
  }
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.project_name}-health"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "health" {
  family = "${var.project_name}-health"

  requires_compatibilities = [
    "EC2"
  ]

  network_mode = "awsvpc"

  cpu    = var.task_cpu
  memory = var.task_memory

  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "health"
      image     = "${var.container_image}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "wget --spider -q http://localhost:${var.container_port}/health || exit 1"
        ]

        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 10
      }

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "health"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "health" {
  name = "${var.project_name}-health"

  cluster = aws_ecs_cluster.main.id

  task_definition = aws_ecs_task_definition.health.arn

  desired_count = var.desired_count

  enable_execute_command = true

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2.name
    weight            = 1
    base              = 1
  }

  network_configuration {
    subnets = var.subnet_ids

    security_groups = [
      var.task_security_group_id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "health"
    container_port   = var.container_port
  }

  depends_on = [
    aws_ecs_cluster_capacity_providers.main
  ]
}
