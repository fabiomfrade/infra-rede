terraform {
  required_providers {
    aws = {
      version = "~> 6.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "tfstates-gl2xl"
    key    = "vpc/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region  = var.regiao
  profile = var.perfil

  default_tags {
    tags = {
      owner      = "fabiomfrade"
      managed-by = "terraform"
    }
  }
}