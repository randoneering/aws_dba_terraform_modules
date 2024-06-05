
# Creates a random password to assign to master/root user. 
resource "random_password" "password" {
  length           = 20
  special          = false
}


resource "aws_db_instance" "sqlsvrinstance" {
  allocated_storage          = var.allocated_storage
  auto_minor_version_upgrade = true
  backup_retention_period = 7
  backup_window = "05:00-05:45"
  copy_tags_to_snapshot      = true
  ca_cert_identifier         = "rds-ca-rsa4096-g1"
  db_subnet_group_name       = data.aws_db_subnet_group.database_subnetgp.name
  deletion_protection        = var.deletion_protection
  engine                     = "sqlserver-web"
  engine_version             = "15.00.4365.2.v1"
  final_snapshot_identifier = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  identifier                 = "${var.app_name_instance}"
  instance_class             = var.instance_class
  kms_key_id                 = var.kms_key_arn
  enabled_cloudwatch_logs_exports = ["error"]
  monitoring_interval        = 60
  monitoring_role_arn        = data.aws_iam_role.default_monitoring_role.arn
  publicly_accessible        = false
  password                   = random_password.password.result
  parameter_group_name       = var.parameter_group
  maintenance_window         = "Sun:06:00-Sun:10:00"
  vpc_security_group_ids = [data.aws_security_group.mssqlsecuritygp.id]
  storage_type               = "gp3"
  storage_encrypted          = true
  skip_final_snapshot = false
  username                   = "dbAdmin"

  tags = {
    tags: "tags"
  }
}
