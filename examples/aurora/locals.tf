locals {
  account                = "1231234241"
  name                   = "aurora-postgres-example"
  engine                 = "aurora-postgresql"
  family                 = "aurora-postgresql15"
  cloudwatch_logs        = ["postgresql"]
  database_name          = "example"
  vpc_id                 = "vpc-1234567890abcdefg"
  subnet_group_name      = "database-subnet-group"
  maintenance_window     = "Sun:05:00-Sun:06:00"
  snapshot_identifier    = null #Set to the snapshot arn you are trying to restore from if restoring from snapshot
  deletion_protection    = true
  replica_count          = 1
  key_owner_iam_arn      = "arn:something"
  key_owner_iam_role     = "example-terraform-role"
  route53zone            = "example.randoneering.tech"
  instance_type          = "db.t4g.medium"
  region                 = "us-east-1"
  vpc_security_group_ids = ["sg-12345670abcdef"]
}