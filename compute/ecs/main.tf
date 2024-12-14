################################################################################
#  ECS Cluster                                                                 #
################################################################################

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.0"

  cluster_name = var.cluster_name

  default_capacity_provider_use_fargate = false

  autoscaling_capacity_providers = {
    default = {
      auto_scaling_group_arn         = module.autoscaling.autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = 1
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 100
      }

      default_capacity_provider_strategy = {
        base   = 1
        weight = 100
      }
    }
  }
}

################################################################################
#  Autoscaling Group                                                           #
################################################################################

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended"
}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.0"

  name = "ecs-${var.cluster_name}-default"

  image_id      = jsondecode(data.aws_ssm_parameter.ecs_ami.value)["image_id"]
  instance_type = var.instance_type

  min_size                        = var.scale.min
  max_size                        = var.scale.max
  desired_capacity                = 0
  ignore_desired_capacity_changes = true
  protect_from_scale_in           = true

  create_iam_instance_profile = true
  iam_role_name               = "ecs-${var.cluster_name}"
  iam_role_description        = "IAM role for the ECS cluster ${var.cluster_name}"
  iam_role_policies           = jsondecode(file("${path.module}/files/iam_role_policies.json"))

  vpc_zone_identifier = var.vpc_zone_identifier
  health_check_type   = "EC2"

  user_data = base64encode(
    templatefile("${path.module}/files/user_data.sh", {
      cluster_name = var.cluster_name
    })
  )

  autoscaling_group_tags = {
    AmazonECSManaged = true
  }
}
