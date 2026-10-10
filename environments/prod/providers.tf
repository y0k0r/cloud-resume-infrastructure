terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    archive = {
      source = "hashicorp/archive"
    }
  }

  backend "s3" {
    bucket = "crc-s3-state"
    key    = "cloud-resume-v2/prod/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}