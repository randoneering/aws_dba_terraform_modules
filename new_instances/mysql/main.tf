# Creates a random password to assign to master/root user. 
resource "random_password" "password" {
  length  = 20
  special = false
}


resource "aws_rds_cluster" "msprovisionedcluster" {
  cluster_identifier              = "${var.app_name_instance}-cluster"
  engine                          = "aurora-mysql"
  engine_version                  = "8.0"
  engine_mode                     = var.engine_mode
  database_name                   = "${var.app_name_instance}DB"
  master_username                 = "dbAdmin"
  master_password                 = random_password.password.result
  db_cluster_parameter_group_name = var.param_grp
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  skip_final_snapshot             = false
  db_subnet_group_name            = data.aws_db_subnet_group.database_subnetgp.name
  copy_tags_to_snapshot           = true
  allow_major_version_upgrade     = true
  enabled_cloudwatch_logs_exports = ["slowquery", "error", "audit"]
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_arn
  vpc_security_group_ids          = [data.aws_security_group.mysqlsecuritygp.id]
  preferred_maintenance_window    = "Sun:05:00-Sun:05:30"
  deletion_protection             = var.deletion_protection
  tags = {
    tag: "tag"
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
  db_subnet_group_name         = data.aws_db_subnet_group.database_subnetgp.name
  monitoring_interval          = 60
  auto_minor_version_upgrade   = true
  monitoring_role_arn          = data.aws_iam_role.default_monitoring_role.arn
  preferred_maintenance_window = "Sun:05:00-Sun:05:30"
}