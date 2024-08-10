resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_db_instance" "msprovisionedinstance" {
  identifier                      = var.app_name_instance
  engine                          = var.db_engine
  engine_version                  = var.mysql_engine_version
  db_name                         = var.database_name
  username                        = var.admin_username
  password                        = random_password.password.result
  instance_class                  = var.instance_class
  parameter_group_name            = var.parameter_group
  publicly_accessible             = false
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  snapshot_identifier             = var.snapshot_identifier
  skip_final_snapshot             = false
  db_subnet_group_name            = var.database_subnetgp
  copy_tags_to_snapshot           = true
  allow_major_version_upgrade     = true
  monitoring_interval             = var.monitoring_window
  auto_minor_version_upgrade      = true
  monitoring_role_arn             = var.rds_monitoring_role_arn
  enabled_cloudwatch_logs_exports = ["slowquery", "error", "audit"]
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_arn
  vpc_security_group_ids          = [var.mysqlsecuritygp]
  maintenance_window              = var.maintenance_window
  deletion_protection             = var.deletion_protection
  tags = {
    owner : "yournamehere"
  }

  lifecycle {
    ignore_changes = [snapshot_identifier, username, identifier]
  }


}