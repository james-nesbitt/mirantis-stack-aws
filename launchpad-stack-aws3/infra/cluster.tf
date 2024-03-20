
module "cluster" {
  source = "../../cluster"

  name = var.name

  network = var.network

  nodegroups = var.nodegroups

  ingresses = merge(
    local.mke_ingresses,
    local.has_msr ? local.msr_ingresses : {},
    var.ingresses
  )
  securitygroups = merge(
    local.common_security_groups,
    local.mke_securitygroups,
    local.has_msr ? local.msr_securitygroups : {},
    var.securitygroups
  )

  extra_tags       = var.extra_tags
  windows_password = var.windows_password
}
