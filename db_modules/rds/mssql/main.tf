resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_db_instance" "sqlsvrinstance" {
  allocated_storage               = var.allocated_storage
  auto_minor_version_upgrade      = true
  backup_retention_period         = 7
  backup_window                   = "05:00-05:45"
  copy_tags_to_snapshot           = true
  ca_cert_identifier              = "rds-ca-rsa4096-g1"
  db_subnet_group_name            = var.database_subnetgp
  deletion_protection             = var.deletion_protection
  engine                          = var.db_engine
  engine_version                  = var.mssql_engine_version
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  identifier                      = var.app_name_instance
  instance_class                  = var.instance_class
  kms_key_id                      = var.kms_key_arn
  enabled_cloudwatch_logs_exports = ["error"]
  monitoring_interval             = var.monitoring_window
  monitoring_role_arn             = var.rds_monitoring_role
  publicly_accessible             = false
  password                        = random_password.password.result
  parameter_group_name            = var.parameter_group
  maintenance_window              = var.maintenance_window
  vpc_security_group_ids          = [var.mssqlsecuritygp]
  storage_type                    = var.storage_type
  storage_encrypted               = true
  skip_final_snapshot             = false
  username                        = var.admin_username
  tags = {
    owner : "yournamehere"
  }
}


