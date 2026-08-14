# Preserve existing state when resources moved into modules.
# Safe no-op if state is empty (fresh lab).

moved {
  from = aws_vpc.main
  to   = module.network.aws_vpc.main
}

moved {
  from = aws_internet_gateway.main
  to   = module.network.aws_internet_gateway.main
}

moved {
  from = aws_subnet.public_a
  to   = module.network.aws_subnet.public_a
}

moved {
  from = aws_subnet.public_b
  to   = module.network.aws_subnet.public_b
}

moved {
  from = aws_route_table.public
  to   = module.network.aws_route_table.public
}

moved {
  from = aws_route_table_association.public_a
  to   = module.network.aws_route_table_association.public_a
}

moved {
  from = aws_route_table_association.public_b
  to   = module.network.aws_route_table_association.public_b
}

moved {
  from = aws_ecs_cluster.main
  to   = module.ecs.aws_ecs_cluster.main
}

moved {
  from = aws_launch_template.ecs
  to   = module.ecs.aws_launch_template.ecs
}

moved {
  from = aws_autoscaling_group.ecs
  to   = module.ecs.aws_autoscaling_group.ecs
}

moved {
  from = aws_ecs_capacity_provider.ec2
  to   = module.ecs.aws_ecs_capacity_provider.ec2
}

moved {
  from = aws_ecs_cluster_capacity_providers.main
  to   = module.ecs.aws_ecs_cluster_capacity_providers.main
}

moved {
  from = aws_cloudwatch_log_group.ecs
  to   = module.ecs.aws_cloudwatch_log_group.ecs
}

moved {
  from = aws_ecs_task_definition.health
  to   = module.ecs.aws_ecs_task_definition.health
}

moved {
  from = aws_ecs_service.health
  to   = module.ecs.aws_ecs_service.health
}
