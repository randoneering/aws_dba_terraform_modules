resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_rds_cluster" "pgsrvlesscluster" {
  cluster_identifier              = "${var.app_name_instance}-cluster"
  engine                          = var.db_engine
  engine_version                  = var.pg_engine_version
  engine_mode                     = var.engine_mode
  database_name                   = var.database_name
  master_username                 = var.admin_username
  master_password                 = random_password.password.result
  db_cluster_parameter_group_name = var.parameter_group
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  db_subnet_group_name            = var.database_subnetgp
  copy_tags_to_snapshot           = true
  allow_major_version_upgrade     = true
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  kms_key_id                      = var.kms_key_arn
  storage_encrypted               = true
  vpc_security_group_ids          = [var.pgsecuritygp]
  preferred_maintenance_window    = var.maintenance_window
  deletion_protection             = var.deletion_protection
  tags = {
    owner : "dyournamehere"
  }
  serverlessv2_scaling_configuration {
    max_capacity = var.serverless_max
    min_capacity = var.serverless_min
  }

}

resource "aws_rds_cluster_instance" "pgsrvlessinstance" {
  count                        = var.number_of_instances
  cluster_identifier           = aws_rds_cluster.pgsrvlesscluster.id
  identifier                   = "${var.app_name_instance}-${count.index + 1}"
  instance_class               = var.instance_class
  engine                       = aws_rds_cluster.pgsrvlesscluster.engine
  engine_version               = aws_rds_cluster.pgsrvlesscluster.engine_version
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