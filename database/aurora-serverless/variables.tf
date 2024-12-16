variable "aws_region" {
  type        = string
  description = "The AWS region to deploy the infrastructure"
  default     = "ap-northeast-2"
}

variable "aurora_cluster_configurations" {
  type = list(
    object({
      name            = string
      engine          = string
      engine_version  = string
      engine_mode     = string
      master_username = string

      vpc_id            = string
      subnet_group_name = string
      security_group_rules = list(
        object({
          type        = string
          from_port   = number
          to_port     = number
          protocol    = string
          cidr_blocks = list(string)
        })
      )

      scale = object({
        min                      = number
        max                      = number
        auto_pause               = bool
        seconds_until_auto_pause = number
      })

      instances = list(
        object({
          name = string
        })
      )
    })
  )
  description = "The Aurora cluster configuration"
  default     = []
}
