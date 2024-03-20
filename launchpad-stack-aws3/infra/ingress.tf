
locals {

  // standard MKE ingresses for the UI, and the kube API
  mke_ingresses = {
    "mke" = {
      description = "MKE ingress for UI and Kube"
      nodegroups  = [for k, ng in var.nodegroups : k if ng.role == "manager"]

      routes = {
        "mke" = {
          port_incoming = 443
          port_target   = 443
          protocol      = "TCP"
        }
        "kube" = {
          port_incoming = 6443
          port_target   = 6443
          protocol      = "TCP"
        }
      }
    },
  }

  // standard MSR ingresses for the UI, and the kube API
  msr_ingresses = {
    // standard ingress for MSR UI
    "msr" = {
      description = "MSR ingress for UI"
      nodegroups  = [for k, ng in var.nodegroups : k if ng.role == local.launchpad_role_msr]

      routes = {
        "ui-http" = {
          port_incoming = 80
          port_target   = 80
          protocol      = "TCP"
        }
        "ui-https" = {
          port_incoming = 443
          port_target   = 443
          protocol      = "TCP"
        }
      }
    }
  }

}
