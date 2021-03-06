#-----------------------------------------------------------------------------------------
# Read variables
#-----------------------------------------------------------------------------------------
variable "region" {}
variable "name" {}
variable "vpc_cidr" {}
variable "azs" {}
variable "env" {}

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
  profile = "terraform" #[aws config --profile ***]で名前付きプロファイルを作成
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

#-----------------------------------------------------------------------------------------
# EC2
#-----------------------------------------------------------------------------------------

module "ec2" {
  source      = "./modules/ec2"
  name        = var.name
  azs         = var.azs
  vpc_id      = module.network.vpc_id
  pub_subnets = module.network.pub_subnets
  env         = var.env

}

#-----------------------------------------------------------------------------------------
# RDS MySQL
#-----------------------------------------------------------------------------------------

module "rds" {
  source      = "./modules/rds"
  name        = var.name
  azs         = var.azs
  vpc_id      = module.network.vpc_id
  pri_subnets = module.network.pri_subnets
  db_user     = var.db_user
  db_password = var.db_password
  env         = var.env

}

#-----------------------------------------------------------------------------------------
# S3
#-----------------------------------------------------------------------------------------

module "s3" {
  source = "./modules/s3"
  name   = var.name
  env    = var.env
}

#-----------------------------------------------------------------------------------------
# ALB
#-----------------------------------------------------------------------------------------

module "alb" {
  source          = "./modules/alb"
  name            = var.name
  vpc_id          = module.network.vpc_id
  env             = var.env
  pub_subnets     = module.network.pub_subnets
  webserver_sg_id = module.ec2.webserver_sg_id
  ec2_id          = module.ec2.ec2_id
}
