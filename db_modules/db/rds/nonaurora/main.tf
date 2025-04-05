locals {
  port                = var.port == "" ? var.engine == "postgresql" ? "5432" : "3306" : var.port
  identifier          = var.use_custom_instance_identifier ? var.custom_instance_identifier : "${var.name}-${var.environment}"
  master_password     = var.password == "" ? random_password.password.result : var.password
  timestamp           = timestamp()
  timestamp_sanitized = replace(local.timestamp, "/[-| |T|Z|:]/", "")

  name = var.name
}

resource "random_password" "password" {
  length  = 20
  special = false
}

resource "aws_db_instance" "rds_instance" {
  identifier                  = local.identifier
  engine                      = var.engine
  engine_version              = var.engine_version
  db_name                     = var.database_name
  username                    = var.username
  password                    = random_password.password.result
  instance_class              = var.instance_class
  parameter_group_name        = aws_db_parameter_group.param_group.name
  publicly_accessible         = false
  allocated_storage           = var.allocated_storage
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately
  availability_zone           = var.availability_zone
  final_snapshot_identifier   = "${var.name}-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  snapshot_identifier         = var.snapshot_identifier
  skip_final_snapshot         = false
  db_subnet_group_name        = var.db_subnet_group_name
  copy_tags_to_snapshot       = var.copy_tags_to_snapshot
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.preferred_backup_window
  blue_green_update {
    enabled = var.blue_green_enabled
  }
  ca_cert_identifier                    = var.ca_cert_identifier
  delete_automated_backups              = var.delete_automated_backups
  monitoring_interval                   = var.monitoring_interval
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  domain                                = var.domain
  domain_iam_role_name                  = var.domain_iam_role_name
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  iops                                  = var.iops
  max_allocated_storage                 = var.max_allocated_storage
  monitoring_role_arn                   = data.aws_iam_role.rds_monitoring_role.arn
  multi_az                              = var.multi_az
  option_group_name                     = var.option_group_name
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_kms_key_id
  performance_insights_retention_period = var.performance_insights_retention_period
  storage_encrypted                     = true
  storage_type                          = var.storage_type
  storage_throughput                    = var.storage_throughput
  kms_key_id                            = var.kms_key_id
  vpc_security_group_ids                = var.vpc_security_group_ids
  maintenance_window                    = var.preferred_maintenance_window
  deletion_protection                   = var.deletion_protection
  tags                                  = merge(var.resource_tags, var.required_tags)

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []

    content {
      restore_time                             = lookup(restore_to_point_in_time.value, "restore_time", null)
      source_db_instance_automated_backups_arn = lookup(restore_to_point_in_time.value, "source_db_instance_automated_backups_arn", null)
      source_db_instance_identifier            = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id                   = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      use_latest_restorable_time               = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }


  dynamic "s3_import" {
    for_each = var.s3_import != null ? [var.s3_import] : []

    content {
      source_engine         = var.engine
      source_engine_version = s3_import.value.source_engine_version
      bucket_name           = s3_import.value.bucket_name
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = s3_import.value.ingestion_role
    }
  }
  lifecycle {
    ignore_changes = [snapshot_identifier, username, identifier]
  }
}

resource "aws_db_parameter_group" "param_group" {
  name        = "${var.name}-${var.environment}-parameter-group"
  family      = var.family
  description = "${var.name}-${var.environment}-db-parameter-group"
  tags        = var.required_tags

  dynamic "parameter" {
    for_each = var.db_parameter_group

    content {
      apply_method = parameter.value.apply_method
      name         = parameter.value.name
      value        = parameter.value.value
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

}