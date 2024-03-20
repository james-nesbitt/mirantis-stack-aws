
variable "name" {
  description = "stack/cluster name, used in labelling across the stack."
  type        = string
}

# === AWS specific configuration ===

variable "aws" {
  description = "AWS configuration"
  type = object({
    region = string
  })
  default = {
    region = "us-east-1"
  }
}

# ===  Networking ===

variable "network" {
  description = "Network configuration"
  type = object({
    cidr                 = string
    public_subnet_count  = optional(number, 1)
    private_subnet_count = optional(number, 0)
    enable_nat_gateway   = optional(bool, false)
    enable_vpn_gateway   = optional(bool, false)
    tags                 = optional(map(string), {})
  })
  default = {
    cidr                 = "172.31.0.0/16"
    public_subnet_count  = 3
    private_subnet_count = 0
    enable_nat_gateway   = false
    enable_vpn_gateway   = false
    tags                 = {}
  }
}

# === Machines ===

variable "nodegroups" {
  description = "A map of machine group definitions"
  type = map(object({
    platform    = string
    type        = string
    count       = optional(number, 1)
    volume_size = optional(number, 100)
    role        = string
    public      = optional(bool, true)
    user_data   = optional(string, "")

    tags = optional(map(string), {})
  }))
  default = {}
}

# === Firewalls ===

variable "securitygroups" {
  description = "VPC Network Security group configuration"
  type = map(object({
    description = string
    nodegroups  = list(string) # which nodegroups should get attached to the sg?

    ingress_ipv4 = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      self        = bool
    })), [])
    egress_ipv4 = optional(list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      self        = bool
    })), [])

    tags = optional(map(string), {})
  }))
  default = {}
}

# === Ingresses ===

variable "ingresses" {
  description = "Configure ingress (ALB) for specific nodegroup roles"
  type = map(object({
    description = string
    nodegroups  = list(string) # which nodegroups should get attached to the ingress

    routes = map(object({
      port_incoming = number
      port_target   = number
      protocol      = string
    }))
    tags = optional(map(string), {})
  }))
  default = {}
}

# === Launchpad configuration ===

variable "launchpad" {
  description = "launchpad install configuration"
  type = object({
    drain = bool

    mcr_version = string
    mke_version = string
    msr_version = string // unused if you have no MSR hosts

    mke_connect = object({
      username = string
      password = string
      insecure = bool // true if this endpoint will not use a valid certificate
    })

    skip_create  = bool
    skip_destroy = bool
  })
}

# === Common tags ===

variable "extra_tags" {
  description = "Extra tags that will be added to all provisioned resources, where possible."
  type        = map(string)
  default     = {}
}

variable "windows_password" {
  description = "Password to use with windows & winrm"
  type        = string
  default     = ""
}
