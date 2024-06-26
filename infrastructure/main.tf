terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    required_version = "~> v1.8.5"

  }
  backend "s3" {
    bucket         = "sbraunovic-terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "sbraunovic-terraform-state-lock"
  }
}

provider "aws" {
  region = var.region
}
