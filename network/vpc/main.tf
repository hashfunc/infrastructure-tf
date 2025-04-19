################################################################################
#  VPC                                                                         #
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name                  = var.vpc.name
  cidr                  = var.vpc.cidr
  secondary_cidr_blocks = var.vpc.secondary_cidr_blocks

  azs = [for az in var.vpc.azs : "${var.aws_region}${az}"]

  private_subnets      = var.subnets.private[*].cidr
  private_subnet_names = var.subnets.private[*].name

  public_subnets      = var.subnets.public[*].cidr
  public_subnet_names = var.subnets.public[*].name

  intra_subnets      = var.subnets.intra[*].cidr
  intra_subnet_names = var.subnets.intra[*].name

  database_subnets      = var.subnets.database[*].cidr
  database_subnet_names = var.subnets.database[*].name

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  manage_default_route_table    = false
  manage_default_network_acl    = false
  manage_default_security_group = false

  enable_nat_gateway = true
  single_nat_gateway = var.vpc.single_nat_gateway
}
