variable "cluster_name" {
  type        = string
  description = "The name of the EKS cluster"
}

variable "cluster_version" {
  type        = string
  description = "The version of the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID for the EKS cluster"
}

variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs for the EKS cluster"
}

variable "cluster_service_ipv4_cidr" {
  type        = string
  description = "The CIDR block for the kubernetes service"
  default     = "172.20.0.0/16"
}

variable "cluster_access_cidr_blocks" {
  type = list(object({
    name        = string
    cidr_block  = string
    from_port   = number
    to_port     = number
    ip_protocol = string
  }))
  description = "The CIDR blocks to allow access to the EKS cluster"
  default     = []
}

variable "authentication_mode" {
  type        = string
  description = "The authentication mode for the EKS cluster"
  default     = "API"
}

variable "access_entries" {
  type        = map(any)
  description = "The access entries for the EKS cluster"
  default     = {}
}

variable "fargate_profiles" {
  type        = map(any)
  description = "The Fargate profiles for the EKS cluster"
  default     = {}
}
