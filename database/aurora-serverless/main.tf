data "aws_rds_engine_version" "this" {
  for_each = {
    for config in var.aurora_cluster_configurations
    : config.name => config
  }

  engine  = each.value.engine
  version = each.value.engine_version
}

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 9.0"

  for_each = {
    for config in var.aurora_cluster_configurations
    : config.name => config
  }

  name            = each.value.name
  engine          = data.aws_rds_engine_version.this[each.key].engine
  engine_version  = data.aws_rds_engine_version.this[each.key].version
  engine_mode     = each.value.engine_mode
  master_username = each.value.master_username

  vpc_id               = each.value.vpc_id
  db_subnet_group_name = each.value.subnet_group_name
  security_group_rules = each.value.security_group_rules

  serverlessv2_scaling_configuration = {
    min_capacity             = each.value.scale.min
    max_capacity             = each.value.scale.max
    auto_pause               = each.value.scale.auto_pause
    seconds_until_auto_pause = each.value.scale.seconds_until_auto_pause
  }

  instance_class = "db.serverless"
  instances      = each.value.instances
}
