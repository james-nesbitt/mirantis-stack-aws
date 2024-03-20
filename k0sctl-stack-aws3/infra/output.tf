
output "nodesgroups" {
  description = "Nodegroups with node lists"
  value       = module.cluster.nodegroups
  sensitive   = true
}

output "ingresses" {
  description = "Ingresses with dns information"
  value       = module.cluster.ingresses
}

output "kube_connect" {
  description = "parametrized config for kubernetes/helm provider configuration"
  sensitive   = true
  value = {
    host               = k0sctl_config.cluster.kube_host
    client_certificate = k0sctl_config.cluster.client_cert
    client_key         = k0sctl_config.cluster.private_key
    ca_certificate     = k0sctl_config.cluster.ca_cert
    tlsverifydisable   = k0sctl_config.cluster.kube_skiptlsverify
  }
}

output "kube_yaml" {
  description = "kubernetes config file yaml (for debugging)"
  sensitive   = true
  value       = k0sctl_config.cluster.kube_yaml
}

output "k0sctl_yaml" {
  description = "k0sctl config file yaml (for debugging)"
  sensitive   = true
  value       = k0sctl_config.cluster.k0s_yaml
}
