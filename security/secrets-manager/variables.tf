variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the infrastructure"
}

variable "secrets" {
  type = list(object({
    name        = string
    description = string
  }))
  description = "The specifications of the secrets"
  default     = []
}
