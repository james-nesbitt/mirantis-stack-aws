
locals {

  // role for MSR machines, so that we can detect if msr config is needed
  launchpad_role_msr = "msr"
  // only hosts with these roles will be used for launchpad_yaml
  launchpad_roles = ["manager", "worker", local.launchpad_role_msr]

  // decide if we need msr configuration (the [0] is needed to prevent an error of no msr instances exit)
  has_msr = sum(concat([0], [for k, ng in var.nodegroups : ng.count if ng.role == local.launchpad_role_msr])) > 0

}
