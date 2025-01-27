resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier              = var.name
  engine                          = var.db_engine
  engine_version                  = var.docdb_engine_version
  master_username                 = var.admin_username
  master_password                 = random_password.password.result
  backup_retention_period         = 14
  preferred_backup_window         = "09:00-09:30"
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.name}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  allow_major_version_upgrade     = true
  apply_immediately               = true
  db_subnet_group_name            = var.database_subnetgp
  db_cluster_parameter_group_name = var.parameter_group
  deletion_protection             = var.deletion_protection
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]
  kms_key_id                      = var.kms_key_arn
  preferred_maintenance_window    = var.maintenance_window
  storage_encrypted               = true
  storage_type                    = "standard"
  vpc_security_group_ids          = [var.security_group]
  tags = {
    owner : "youremail/team name here"
  }

}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count                        = 1
  identifier                   = "${var.name}-${count.index + 1}"
  cluster_identifier           = aws_docdb_cluster.docdb.id
  instance_class               = var.instance_class
  auto_minor_version_upgrade   = true
  copy_tags_to_snapshot        = true
  engine                       = var.db_engine
  preferred_maintenance_window = var.maintenance_window
  tags = {
    owner : "youremail/teamn name here"
  }

}