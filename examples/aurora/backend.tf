terraform {

  backend "s3" {
    bucket         = "your_bucket"
    key            = "your/key/target.tfstate"
    region         = "your_region"
    dynamodb_table = "your_dynamo_db_table"
    encrypt        = true
    profile        = "aws_config_profile" #this depends on how you are deploying
  }
}