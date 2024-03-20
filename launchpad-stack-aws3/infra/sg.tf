locals {

  common_security_groups = {
    "permissive" = {
      description = "Common SG for all cluster machines"
      nodegroups  = [for n, ng in var.nodegroups : n]

      ingress_ipv4 = [
        {
          description : "Permissive internal traffic [BAD RULE]"
          from_port : 0
          to_port : 0
          protocol : "-1"
          self : true
          cidr_blocks : []
        },
      ]
      egress_ipv4 = [
        {
          description : "Permissive outgoing traffic"
          from_port : 0
          to_port : 0
          protocol : "-1"
          cidr_blocks : ["0.0.0.0/0"]
          self : false
        }
      ]
    }

  }

  // standard MCR/MKE/MSR firewall rules [here we just leave it open until we can figure this out]
  mke_securitygroups = {
    "manager" = {
      description = "Common security group for manager nodes"
      nodegroups  = [for n, ng in var.nodegroups : n if ng.role == "manager"]

      ingress_ipv4 = [
        {
          description : "Allow https traffic from anywhere"
          from_port : 443
          to_port : 443
          protocol : "tcp"
          self : false
          cidr_blocks : ["0.0.0.0/0"]
        },
        {
          description : "Allow https traffic from anywhere for kube api server"
          from_port : 6443
          to_port : 6443
          protocol : "tcp"
          self : false
          cidr_blocks : ["0.0.0.0/0"]
        },
      ]
    }
  }

  // standard MSR firewall rules [here we just leave it open until we can figure this out]
  msr_securitygroups = {
    "msr" = {
      description = "Common security group for msr nodes"
      nodegroups  = [for n, ng in var.nodegroups : n if ng.role == local.launchpad_role_msr]

      ingress_ipv4 = [
        {
          description : "Allow permissive traffic from anywhere (BAD RULE)"
          from_port : 0
          to_port : 0
          protocol : "tcp"
          self : false
          cidr_blocks : ["0.0.0.0/0"]
        },
      ]
    }
  }

}
