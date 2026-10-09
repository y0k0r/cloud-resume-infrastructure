terraform {

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "crc-s3-state"
    key = "cloud-resume-infra/shared/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
    encrypt = true
  }
}

provider "aws" {
  region  = "us-east-1"
}