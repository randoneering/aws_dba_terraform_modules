terraform {

  backend "s3" {
    bucket         = "rxb-dba-env-tfstate"
    key            = "db/app.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rxb-dba-env-tfstate"
    encrypt        = true
    profile        = "env"

  }
}