
# Creates a random password to assign to master/root user. 
resource "random_password" "password" {
  length           = 20
  special          = false
}

# Creation of docdb cluster
resource "aws_docdb_cluster" "docdb" {
  cluster_identifier = "${var.app_name_instance}"
  engine = "docdb"
  engine_version = "5.0.0" # Change to the version you prefer/desire
  master_username = "dbAdmin"
  master_password = random_password.password.result
  backup_retention_period = 5 # Change to your prefered retention period
  preferred_backup_window = "09:00-09:30" # Time is in UTC
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  allow_major_version_upgrade = true
  apply_immediately = true
  db_subnet_group_name = data.aws_db_subnet_group.database_subnetgp.name
  db_cluster_parameter_group_name = var.parameter_group
  deletion_protection = var.deletion_protection
  enabled_cloudwatch_logs_exports = ["audit","profiler"]
  kms_key_id = var.kms_key_arn
  preferred_maintenance_window = "Sun:05:00-Sun:09:00" # Time is in UTC
  storage_encrypted = true
  storage_type = "standard"
  vpc_security_group_ids = [data.aws_security_group.docdbsecuritygp.id]
  tags = {
    tag: "tag"
  }

}

# Creation of docdb cluster instance
resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 1
  identifier         = "${var.app_name_instance}-${count.index + 1}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "${var.instance_class}"
  auto_minor_version_upgrade = true
  copy_tags_to_snapshot = true
  engine = "docdb"
  preferred_maintenance_window = ""
    tags = {
    tag: "tag"
}
}