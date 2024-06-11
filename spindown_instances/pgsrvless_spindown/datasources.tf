# Default rds monitoring role users for enhanced monitoring
data "aws_iam_role" "default_monitoring_role" {
  name = ""
}

# Subnet group created to include private subnets 
data "aws_db_subnet_group" "database_subnetgp" {
  name = ""
}

# Role used for assigning to KMS key 
data "aws_iam_role" "dba_iam_role" {
  name = ""
}

# Security group that allows traffic inbound only from 5432
data "aws_security_group" "pgsecuritygp" {
  id = ""

}

# Grabs the latest snapshot for the instance
data "aws_db_cluster_snapshot" "latest_snapshot" {
  db_cluster_identifier = "${var.app_name_instance}-cluster"
  most_recent = true
}

