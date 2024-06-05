# Creates a random password to assign to master/root user. 
resource "random_password" "password" {
  length           = 20
  special          = false
}



resource "aws_rds_cluster" "pgsrvlesscluster" {
  cluster_identifier              = "${var.app_name_instance}-cluster"
  engine                          = "aurora-postgresql"
  engine_version                  = "15"
  engine_mode                     = "provisioned"
  database_name                   = "${var.app_name_instance}DB"
  master_username                 = "rxadmin"
  master_password                 = random_password.password.result
  db_cluster_parameter_group_name = var.parameter_group
  skip_final_snapshot             = false
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  snapshot_identifier             = data.aws_db_cluster_snapshot.latest_snapshot.id
  db_subnet_group_name            = data.aws_db_subnet_group.database_subnetgp.name
  copy_tags_to_snapshot           = true
  allow_major_version_upgrade     = true
  enabled_cloudwatch_logs_exports = ["postgresql","upgrade"]
  kms_key_id                      = var.kms_key_arn
  storage_encrypted               = true
  vpc_security_group_ids          = [data.aws_security_group.pgsecuritygp.id]
  preferred_maintenance_window    = "Sun:05:00-Sun:05:30"
  deletion_protection             = var.deletion_protection
  tags = {
    tags: "tags"
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
  db_subnet_group_name         = data.aws_db_subnet_group.database_subnetgp.name
  monitoring_interval          = 60
  auto_minor_version_upgrade   = true
  monitoring_role_arn          = data.aws_iam_role.default_monitoring_role.arn
  preferred_maintenance_window = "Sun:05:00-Sun:05:30"
  tags = {
    tags: "tags"
  }
}

