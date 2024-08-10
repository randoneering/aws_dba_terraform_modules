resource "random_password" "password" {
  length  = 20
  special = false
}


resource "aws_rds_cluster" "msprovisionedcluster" {
  cluster_identifier              = "${var.app_name_instance}-cluster"
  engine                          = var.db_engine
  engine_version                  = var.mysql_engine_version
  engine_mode                     = var.engine_mode
  database_name                   = var.database_name
  master_username                 = var.admin_username
  master_password                 = random_password.password.result
  db_cluster_parameter_group_name = var.parameter_group
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  snapshot_identifier             = var.snapshot_identifier
  skip_final_snapshot             = false
  db_subnet_group_name            = var.database_subnetgp
  copy_tags_to_snapshot           = true
  allow_major_version_upgrade     = true
  enabled_cloudwatch_logs_exports = ["slowquery", "error", "audit"]
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_arn
  vpc_security_group_ids          = [var.mysqlsecuritygp]
  preferred_maintenance_window    = var.maintenance_window
  deletion_protection             = var.deletion_protection
  tags = {
    owner : "yournamehere"
  }

  lifecycle {
    ignore_changes = [snapshot_identifier, master_username, cluster_identifier]
  }

}

resource "aws_rds_cluster_instance" "msprovisionedinstance" {
  count                        = var.number_of_instances
  cluster_identifier           = aws_rds_cluster.msprovisionedcluster.id
  identifier                   = "${var.app_name_instance}-${count.index + 1}"
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.msprovisionedcluster.engine
  engine_version               = aws_rds_cluster.msprovisionedcluster.engine_version
  publicly_accessible          = false
  db_subnet_group_name         = var.database_subnetgp
  monitoring_interval          = var.monitoring_window
  auto_minor_version_upgrade   = true
  monitoring_role_arn          = var.rds_monitoring_role_arn
  preferred_maintenance_window = var.maintenance_window
  tags = {
    owner : "yournamehere"
  }
}