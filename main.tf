#-----------------------------------------------------------------------------------------
# Read variables
#-----------------------------------------------------------------------------------------
variable "region" {}
variable "name" {}
variable "vpc_cidr" {}
variable "azs" {}

#-----------------------------------------------------------------------------------------
# Main
#-----------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.1.0"
  backend "local" {
    path = "terraform.state"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

#-----------------------------------------------------------------------------------------
# Network
#-----------------------------------------------------------------------------------------

module "network" {
  source   = "./modules/network"
  name     = var.name
  vpc_cidr = var.vpc_cidr
  azs      = var.azs
  region   = var.region
}

module "ec2" {
  source      = "./modules/ec2"
  name        = var.name
  azs         = var.azs
  vpc_id      = module.network.vpc_id
  pub_subnets = module.network.pub_subnets

}

/*
module "rds" {
  source = "./modules/rds"
}
*/
