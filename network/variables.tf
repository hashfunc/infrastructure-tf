variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the infrastructure"
}

variable "vpc" {
  type = object({
    name               = string
    cidr               = string
    azs                = list(string)
    single_nat_gateway = bool
  })
  description = "The VPC configuration"
}
