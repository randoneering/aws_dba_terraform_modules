locals {
  account             = "1234123412"
  name                = "eaxmple-docdb"
  database_name       = "example"
  deletion_protection = true
  number_of_instances = 1
  key_owner_iam_arn   = "arn:something"
  key_owner_iam_role  = "example-terraform-role"
  instance_class      = "db.r6g.large"
  region              = "us-east-1"
  security_group      = "sg-1234591fff"
}