resource "aws_vpc_security_group_ingress_rule" "cluster_access" {
  for_each = {
    for cidr_block in var.cluster_access_cidr_blocks :
    cidr_block.name => cidr_block
  }

  security_group_id = module.eks.cluster_security_group_id

  cidr_ipv4   = each.value.cidr_block
  from_port   = each.value.from_port
  ip_protocol = each.value.ip_protocol
  to_port     = each.value.to_port
}
