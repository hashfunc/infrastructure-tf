module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                    = var.vpc_id
  subnet_ids                = var.subnet_ids
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr

  authentication_mode = var.authentication_mode
  access_entries      = var.access_entries

  fargate_profiles = var.fargate_profiles
}
