
resource "random_password" "password" {
  length  = 20
  special = false
}


resource "aws_rds_cluster" "pgprovisionedcluster" {
  allow_major_version_upgrade     = true
  cluster_identifier              = "${var.app_name_instance}-cluster"
  copy_tags_to_snapshot           = true
  database_name                   = var.database_name
  db_cluster_parameter_group_name = var.parameter_group
  db_subnet_group_name            = data.aws_db_subnet_group.database_subnetgp.name
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  engine                          = var.db_engine
  engine_version                  = var.pg_engine_version
  engine_mode                     = var.engine_mode
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  kms_key_id                      = var.kms_key_arn
  master_username                 = var.admin_username
  master_password                 = random_password.password.result
  preferred_maintenance_window    = var.maintenance_window
  skip_final_snapshot             = false
  storage_encrypted               = true
  vpc_security_group_ids          = [var.pgsecuritygp]
  tags = {
    owner : "yournamehere"
  }
}

resource "aws_rds_cluster_instance" "pgprovisionedinstance" {
  count                        = var.number_of_instances
  cluster_identifier           = aws_rds_cluster.pgprovisionedcluster.id
  identifier                   = "${var.app_name_instance}-${count.index + 1}"
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.pgprovisionedcluster.engine
  engine_version               = aws_rds_cluster.pgprovisionedcluster.engine_version
  ca_cert_identifier           = "rds-ca-ecc384-g1"
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