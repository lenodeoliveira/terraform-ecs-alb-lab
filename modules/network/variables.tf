variable "project_name" {
  description = "Prefix used for resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR of the lab VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDRs for the two public subnets (AZ a and b)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Provide exactly two public subnet CIDRs."
  }
}
