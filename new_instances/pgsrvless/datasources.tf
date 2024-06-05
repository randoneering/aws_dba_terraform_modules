
# Default rds monitoring role users for enhanced monitoring
data "aws_iam_role" "default_monitoring_role" {
  name = ""
}

# Subnet group created by our team to use for each instance cluster
data "aws_db_subnet_group" "database_subnetgp" {
  name = ""
}

# Role used for assigning to KMS key (and future resources)
data "aws_iam_role" "dba_iam_role" {
  name = ""
}

# Security group allowing only traffic in via 5432/default port
data "aws_security_group" "pgsecuritygp" {
  id = ""

}


