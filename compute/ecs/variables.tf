variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the infrastructure"
}

variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
  default     = "ecs-cluster"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the ecs cluster"
}

variable "scale" {
  type = object({
    min = number
    max = number
  })
  description = "The scaling configuration for the ecs cluster"
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "The VPC zone identifier to use for the ecs cluster"
}
