
// prepare values to make it easier to feed into launchpad
locals {
  // The SAN URL for the MKE load balancer ingress
  MKE_URL = module.cluster.ingresses["mke"].lb_dns
  // The SAN URL for the MSR load balancer ingress 
  MSR_URL = local.has_msr ? module.cluster.ingresses["msr"].lb_dns : ""

  // flatten nodegroups into a set of objects with the info needed for each node, by combining the group details with the node detains
  launchpad_hosts_ssh = merge([for k, ng in module.cluster.nodegroups : { for l, ngn in ng.nodes : ngn.label => {
    label : ngn.label
    id : ngn.instance_id
    role : ng.role

    address : ngn.public_address

    ssh_address : ngn.public_ip
    ssh_user : ng.ssh_user
    ssh_port : ng.ssh_port
    ssh_key_path : abspath(module.cluster.key.filename)
  } if contains(local.launchpad_roles, ng.role) && ng.connection == "ssh" }]...)
  launchpad_hosts_winrm = merge([for k, ng in module.cluster.nodegroups : { for l, ngn in ng.nodes : ngn.label => {
    label : ngn.label
    id : ngn.instance_id
    role : ng.role

    address : ngn.public_address

    winrm_address : ngn.public_ip
    winrm_user : ng.winrm_user
    winrm_password : var.windows_password
    winrm_useHTTPS : ng.winrm_useHTTPS
    winrm_insecure : ng.winrm_insecure
  } if contains(local.launchpad_roles, ng.role) && ng.connection == "winrm" }]...)

}

resource "launchpad_config" "cluster" {
  skip_create  = var.launchpad.skip_create
  skip_destroy = var.launchpad.skip_destroy

  metadata {
    name = var.name
  }
  spec {
    cluster {
      prune = true
    }

    mcr {
      version  = var.launchpad.mcr_version
      repo_url = "https://repos.mirantis.com"
      channel  = "stable"
    }
    mke {
      version        = var.launchpad.mke_version
      image_repo     = "docker.io/mirantis"
      admin_username = var.launchpad.mke_connect.username
      admin_password = var.launchpad.mke_connect.password

      install_flags = [
        "--san=${local.MKE_URL}",
      ]
      upgrade_flags = [
        "--force-recent-backup",
      ]
    }

    dynamic "msr" {
      for_each = local.has_msr ? [1] : []

      content {
        version     = var.launchpad.msr_version
        image_repo  = "docker.io/mirantis"
        replica_ids = "sequential"

        install_flags = [
          "--ucp-insecure-tls",
          "--dtr-external-url=${local.MSR_URL}",
        ]
      }
    }

    // add hosts for every *nix/ssh host 
    dynamic "host" {
      for_each = nonsensitive(local.launchpad_hosts_ssh)

      content {
        role = host.value.role
        ssh {
          address  = host.value.ssh_address
          key_path = host.value.ssh_key_path
          user     = host.value.ssh_user
        }
      }
    }

    // add hosts for every windows/winrm host
    dynamic "host" {
      for_each = nonsensitive(local.launchpad_hosts_winrm)

      content {
        role = host.value.role
        winrm {
          address   = host.value.winrm_address
          user      = host.value.winrm_user
          password  = host.value.winrm_password
          insecure  = host.value.winrm_insecure
          use_https = host.value.winrm_useHTTPS
        }
      }
    }
  }
}

locals {
  // ------- Ye old launchpad yaml (just for debugging)
  launchpad_yaml = <<-EOT
apiVersion: launchpad.mirantis.com/mke/v1.4
kind: mke%{if local.has_msr}+msr%{endif}
metadata:
  name: ${var.name}
spec:
  cluster:
    prune: true
  hosts:
%{~for h in local.launchpad_hosts_ssh}
  # ${h.label} ${h.id} (ssh)
  - role: ${h.role}
    ssh:
      address: ${h.ssh_address}
      user: ${h.ssh_user}
      keyPath: ${h.ssh_key_path}
%{~endfor}
%{~for h in local.launchpad_hosts_winrm}
  # ${h.label} ${h.id} (winrm)
  - role: ${h.role}
    winRM:
      address: ${h.winrm_address}
      user: ${h.winrm_user}
      password: ${h.winrm_password}
      useHTTPS: ${h.winrm_useHTTPS}
      insecure: ${h.winrm_insecure}
%{~endfor}
  mke:
    version: ${var.launchpad.mke_version}
    imageRepo: docker.io/mirantis
    adminUsername: ${var.launchpad.mke_connect.username}
    adminPassword: ${var.launchpad.mke_connect.password}
    installFlags: 
    - "--san=${local.MKE_URL}"
  mcr:
    version: ${var.launchpad.mcr_version}
    repoURL: https://repos.mirantis.com
    channel: stable
%{if local.has_msr}
  msr:
    version: ${var.launchpad.msr_version}
    imageRepo: docker.io/mirantis
    replicaIDs: sequential
    installFlags:
    - "--ucp-insecure-tls"
    - "--dtr-external-url=${local.MSR_URL}"
%{endif}
EOT

}
