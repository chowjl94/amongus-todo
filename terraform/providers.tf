terraform {
  required_version = "= 1.0.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.54"
    }
  }

#   backend "local" {
#     path = "./local.terraform.tfstate"
#   }
  backend "remote" {
    organization = "cicd-dev"

    workspaces {
      name = "cicd-dev"
    }
  }
}

provider "aws" {
  region  = "ap-southeast-1"
}
