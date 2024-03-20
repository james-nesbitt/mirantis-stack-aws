terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    k0sctl = {
      source = "Mirantis/k0sctl"
    }
  }
}

provider "aws" {
  region = var.aws.region
}
