variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the netbird routing peer"
}

variable "vpc_zone_identifier" {
  type        = list(string)
  description = "The VPC zone identifier to use for the netbird routing peer"
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the netbird routing peer"
}

variable "instance_ami" {
  type        = string
  description = "The AMI to use for the netbird routing peer instance"
}

variable "secret_name" {
  type        = string
  description = "The secret name to use for the netbird routing peer"
}

variable "kms_alias" {
  type        = string
  description = "The KMS alias to use for the netbird routing peer secrets"
}
