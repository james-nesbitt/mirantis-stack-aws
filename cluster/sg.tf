locals {
  common_security_groups = {

    "ssh" = {
      description = "Security for group for openning ssh port"
      nodegroups  = [for n, ng in local.nodegroups_wplatform : n if ng.platform == ""] # platform attribute is empty for linux in aws_ami data source

      ingress_ipv4 = [
        {
          description : "Allow ssh traffic from anywhere"
          from_port : 22
          to_port : 22
          protocol : "tcp"
          self : false
          cidr_blocks : ["0.0.0.0/0"]
        },
      ]
    }

    "winrm" = {
      description = "Security for group for openning winrm ports"
      nodegroups  = [for n, ng in local.nodegroups_wplatform : n if ng.platform == "windows"]

      ingress_ipv4 = [
        {
          description : "Allow winrm traffic from anywhere"
          from_port : 5985
          to_port : 5986
          protocol : "tcp"
          self : false
          cidr_blocks : ["0.0.0.0/0"]
        },
      ]
    }

  }
}
