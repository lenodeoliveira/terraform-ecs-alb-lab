output "vpc_id" {
  description = "ID of the lab VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the two public subnets."
  value = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway."
  value       = aws_internet_gateway.main.id
}
