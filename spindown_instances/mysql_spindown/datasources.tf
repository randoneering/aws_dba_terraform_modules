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
# Role used for assigning to KMS key 
data "aws_iam_role" "dba_iam_role" {
    name = ""
}

# Grabs the latest snapshot for the instance
data "aws_db_cluster_snapshot" "latest_snapshot" {
  db_cluster_identifier = "${var.app_name_instance}-cluster"
  include_shared = true
}
