terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

    # Create backend for terraform state and lockfile
    # https://spacelift.io/blog/terraform-s3-backend
  backend "s3" {
    bucket  = ""
    # key is the folder directory IN the bucket
    key     = "appname_folder/appname.tfstate"
    region  = "us-east-1"
    profile = ""
    
    dynamodb_table = ""
    encrypt        = true

  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1" # choose your default region
  profile = ""
}
