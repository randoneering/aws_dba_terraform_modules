terraform {

  backend "s3" {
    bucket         = "your_bucket"
    key            = "app/app.tfstate"
    region         = "your_egion"
    dynamodb_table = "dynamodb_table"
    encrypt        = true
    profile        = "aws_config_profile" #this depends on how you are deploying

  }
}