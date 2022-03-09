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
  region     = "ap-northeast-1"
}
