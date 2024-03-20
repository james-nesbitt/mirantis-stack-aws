
module "cluster" {
  source = "../../cluster"

  name = var.name

  network = var.network

  nodegroups = var.nodegroups

  ingresses = merge(
    local.k0s_ingresses,
    var.ingresses,
  )
  securitygroups = merge(
    local.common_security_groups,
    local.k0s_securitygroups,
    var.securitygroups
  )

  extra_tags = var.extra_tags
}
