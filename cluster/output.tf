
output "nodegroups" {
  description = "Nodegroups with node lists"
  value       = local.nodegroups_wnodes
  sensitive   = true
}

output "ingresses" {
  description = "Ingresses with dns information"
  value       = local.ingresses_wlbs
}

output "platforms" {
  description = "Platforms used in the stack"
  value       = local.platforms_with_ami
  sensitive   = true
}

output "key" {
  description = "SSH Key path"
  value       = local_sensitive_file.ssh_private_key
  sensitive   = true
}
