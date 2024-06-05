
# Default rds monitoring role users for enhanced monitoring
data "aws_iam_role" "default_monitoring_role" {
  name = ""
}

# Subnet group created to include private subnets 
data "aws_db_subnet_group" "database_subnetgp" {
  name = "randoneering-dba-subnetgp-private"
}

# Role used for assigning to KMS key (and future resources)
data "aws_iam_role" "dba_iam_role" {
  name = "aws_iam_dba_role"
}


# Security group that allows only traffic via default docdb port 27017
data "aws_security_group" "docdbsecuritygp" {
  id = ""
}


