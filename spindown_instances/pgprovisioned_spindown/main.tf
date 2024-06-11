# Generate Random Password for Admin/Root user
resource "random_password" "password" {
  length           = 20
  special          = false
}


# Provision Cluster
resource "aws_rds_cluster" "pgprovisionedcluster" {
  allow_major_version_upgrade     = true
  cluster_identifier              = "${var.app_name_instance}-cluster"
  copy_tags_to_snapshot           = true
  database_name                   = "${var.app_name_instance}DB"
  db_cluster_parameter_group_name = "${var.parameter_group}"
  db_subnet_group_name            = data.aws_db_subnet_group.database_subnetgp.name
  deletion_protection = var.deletion_protection
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  engine                          = "aurora-postgresql"
  engine_version                  = "15"
  engine_mode                     = "provisioned"
  final_snapshot_identifier       = "${var.app_name_instance}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  kms_key_id                      = var.kms_key_arn
  master_username                 = "" # your root/admin username 
  master_password                 = random_password.password.result
  preferred_maintenance_window    = "Sun:05:00-Sun:05:30" # in UTC
  skip_final_snapshot             = false
  snapshot_identifier             = data.aws_db_cluster_snapshot.latest_snapshot.id
  storage_encrypted               = true
  vpc_security_group_ids          = [data.aws_security_group.pgsecuritygp.id]
  tags = {
    tags = "tags"
}

  lifecycle {
    ignore_changes = [snapshot_identifier] # ignores the changing identifier as each terraform plan will create a new id here
  }
}

# Provision Instance
resource "aws_rds_cluster_instance" "pgprovisionedinstance" {
  count                      = var.number_of_instances
  cluster_identifier         = aws_rds_cluster.pgprovisionedcluster.id
  identifier                 = "${var.app_name_instance}-${count.index + 1}" # Counter for each # of instance/reader created
  instance_class             = var.instance_class
  engine                     = aws_rds_cluster.pgprovisionedcluster.engine
  engine_version             = aws_rds_cluster.pgprovisionedcluster.engine_version
  ca_cert_identifier         = "rds-ca-ecc384-g1"
  publicly_accessible        = false
  db_subnet_group_name       = data.aws_db_subnet_group.database_subnetgp.name
  monitoring_interval        = 60 # longest monitoring interval
  auto_minor_version_upgrade = true
  monitoring_role_arn        = data.aws_iam_role.default_monitoring_role.arn
  preferred_maintenance_window    = "Sun:05:00-Sun:05:30" # in  UTC
  tags = {
    tags = "tags"
  }
}