terraform {
  required_version = ">=1.8.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

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



resource "aws_iam_openid_connect_provider" "this" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = [var.github_repo]
  thumbprint_list = ["1b511abead59c6ce207077c0bf0e0043b1382612",
  "959cb2b52b4ad201a593847abca32ff48f838c2e"]
}
