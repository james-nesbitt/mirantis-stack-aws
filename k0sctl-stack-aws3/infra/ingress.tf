
locals {

  // standard Kube ingresses for k0s
  k0s_ingresses = {
    "kube" = {
      description = "ingress for Kube API"
      nodegroups  = [for k, ng in var.nodegroups : k if ng.role == "controller"]

      routes = {
        "kube" = {
          port_incoming = 6443
          port_target   = 6443
          protocol      = "TCP"
        }
      }
    }
  }

}
