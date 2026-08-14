# Image registry for the NestJS health service.
# Terraform creates the repo; you still build and push the image yourself.

resource "aws_ecr_repository" "health" {
  name                 = "${var.project_name}-health"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.project_name}-health"
  }
}
