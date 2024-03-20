
output "nodegroups" {
  description = "Nodegroups with node lists"
  value       = module.cluster.nodegroups
  sensitive   = true
}

output "ingresses" {
  description = "Ingresses with dns information"
  value       = module.cluster.ingresses
}

output "mke_connect" {
  description = "Connection information for connecting to MKE"
  sensitive   = true
  value = {
    host     = local.MKE_URL
    username = var.launchpad.mke_connect.username
    password = var.launchpad.mke_connect.password
    insecure = var.launchpad.mke_connect.insecure
  }
}

// ------- Ye old launchpad yaml (just for debugging)
output "launchpad_yaml" {
  description = "launchpad config file yaml (for debugging)"
  sensitive   = true
  value       = local.launchpad_yaml
}
