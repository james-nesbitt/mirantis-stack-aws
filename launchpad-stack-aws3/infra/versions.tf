terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    launchpad = {
      source = "Mirantis/launchpad"
    }
  }
}

provider "aws" {
  region = var.aws.region
}
