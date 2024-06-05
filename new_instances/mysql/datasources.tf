# Default rds monitoring role users for enhanced monitoring
data "aws_iam_role" "default_monitoring_role" {
  name = ""
}

# Subnet group created to include private subnets 
data "aws_db_subnet_group" "database_subnetgp" {
  name = ""
}

# Security group that allows traffic inbound only from 3306
data "aws_security_group" "mysqlsecuritygp" {
  id = ""

}
# Role used for assigning to KMS key (and future resources)
data "aws_iam_role" "dba_iam_role" {
  name = ""
}

