terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
  default_tags {
    tags = {
      "Owner"   = var.owner
    }
  }
}

module "network" {}

module "storage" {}

module "database" {}

module "alb" {}

module "nlb" {}

module "asg_core" {}

module "asg_engine" {}
