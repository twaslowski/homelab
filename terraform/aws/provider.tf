terraform {

  backend "s3" {
    bucket = "246770851643-eu-central-1-terraform-state"
    region = "eu-central-1"
    key    = "homelab/aws/terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      "created-by"  = "terraform"
      "application" = "homelab"
      "environment" = "production"
    }
  }
}