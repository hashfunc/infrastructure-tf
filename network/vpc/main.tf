################################################################################
#  VPC                                                                         #
################################################################################

locals {
  vpc = {
    name = var.vpc.name
    cidr = var.vpc.cidr
    azs  = var.vpc.azs
  }

  subnets = {
    public = {
      main = {
        cidrs = cidrsubnets(
          cidrsubnet(local.vpc.cidr, 4, 0),
          [for _ in local.vpc.azs : 4]...
        )
      }
    }
    private = {
      main = {
        cidrs = cidrsubnets(
          cidrsubnet(local.vpc.cidr, 4, 1),
          [for _ in local.vpc.azs : 4]...
        )
      }
    }
    intra = {
      main = {
        cidrs = cidrsubnets(
          cidrsubnet(local.vpc.cidr, 4, 2),
          [for _ in local.vpc.azs : 4]...
        )
      }
    },
    database = {
      main = {
        cidrs = cidrsubnets(
          cidrsubnet(local.vpc.cidr, 4, 3),
          [for _ in local.vpc.azs : 4]...
        )
      }
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.vpc.name
  cidr = local.vpc.cidr

  azs = [for az in local.vpc.azs : "${var.aws_region}${az}"]

  private_subnets = flatten([
    for subnet in local.subnets.private : subnet.cidrs
  ])
  private_subnet_names = flatten([
    for name, subnet in local.subnets.private : [
      for idx in range(length(subnet.cidrs)) :
      "${local.vpc.name}-private-${name}-${idx}"
    ]
  ])

  public_subnets = flatten([
    for subnet in local.subnets.public : subnet.cidrs
  ])
  public_subnet_names = flatten([
    for name, subnet in local.subnets.public : [
      for idx in range(length(subnet.cidrs)) :
      "${local.vpc.name}-public-${name}-${idx}"
    ]
  ])

  intra_subnets = flatten([
    for subnet in local.subnets.intra : subnet.cidrs
  ])
  intra_subnet_names = flatten([
    for name, subnet in local.subnets.intra : [
      for idx in range(length(subnet.cidrs)) :
      "${local.vpc.name}-intra-${name}-${idx}"
    ]
  ])

  database_subnets = flatten([
    for subnet in local.subnets.database : subnet.cidrs
  ])
  database_subnet_names = flatten([
    for name, subnet in local.subnets.database : [
      for idx in range(length(subnet.cidrs)) :
      "${local.vpc.name}-database-${name}-${idx}"
    ]
  ])

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  manage_default_route_table    = false
  manage_default_network_acl    = false
  manage_default_security_group = false

  enable_nat_gateway = true
  single_nat_gateway = var.vpc.single_nat_gateway

}
