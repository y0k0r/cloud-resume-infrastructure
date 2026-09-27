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
    key = "crc-aws-backend/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "crc-s3-state-locks"
    encrypt = true
  }
}

provider "aws" {
  region  = "us-east-1"
}