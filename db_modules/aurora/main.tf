locals {
  port                 = var.port == "" ? var.engine == "aurora-postgresql" ? "5432" : "3306" : var.port
  master_password      = var.password == "" ? random_password.master_password.result : var.password
  db_subnet_group_name = var.db_subnet_group_name
  backtrack_window     = (var.engine == "aurora-mysql" || var.engine == "aurora") && var.engine_mode != "serverless" ? var.backtrack_window : 0

  rds_enhanced_monitoring_arn  = join("", aws_iam_role.rds_enhanced_monitoring.*.arn)
  rds_enhanced_monitoring_name = join("", aws_iam_role.rds_enhanced_monitoring.*.name)


  timestamp           = timestamp()
  timestamp_sanitized = replace(local.timestamp, "/[-| |T|Z|:]/", "")

  name = "aurora-${var.name}"
}


resource "random_password" "master_password" {
  length  = 16
  special = false
}

resource "aws_rds_cluster" "rds_cluster" {
  global_cluster_identifier           = var.global_cluster_identifier
  cluster_identifier                  = var.name
  replication_source_identifier       = var.replication_source_identifier
  source_region                       = var.source_region
  engine                              = var.engine
  engine_mode                         = var.engine_mode
  engine_version                      = var.engine_version
  enable_http_endpoint                = var.enable_http_endpoint
  kms_key_id                          = var.kms_key_id
  database_name                       = var.database_name
  master_username                     = var.username
  master_password                     = local.master_password
  final_snapshot_identifier           = "${var.final_snapshot_identifier_prefix}-${var.name}-${random_id.snapshot_identifier.hex}-${local.timestamp_sanitized}"
  skip_final_snapshot                 = var.skip_final_snapshot
  deletion_protection                 = var.deletion_protection
  backup_retention_period             = var.backup_retention_period
  preferred_backup_window             = var.preferred_backup_window
  preferred_maintenance_window        = var.preferred_maintenance_window
  port                                = local.port
  db_subnet_group_name                = var.db_subnet_group_name
  vpc_security_group_ids              = var.vpc_security_group_ids
  snapshot_identifier                 = var.snapshot_identifier
  storage_encrypted                   = var.storage_encrypted
  apply_immediately                   = var.apply_immediately
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.cluster_param_grp.id
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  backtrack_window                    = local.backtrack_window
  copy_tags_to_snapshot               = var.copy_tags_to_snapshot
  iam_roles                           = var.iam_roles
  allow_major_version_upgrade         = var.allow_major_version_upgrade

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  dynamic "scaling_configuration" {
    for_each = length(keys(var.scaling_configuration)) == 0 ? [] : [
    var.scaling_configuration]

    content {
      auto_pause               = lookup(scaling_configuration.value, "auto_pause", null)
      max_capacity             = lookup(scaling_configuration.value, "max_capacity", null)
      min_capacity             = lookup(scaling_configuration.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(scaling_configuration.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(scaling_configuration.value, "timeout_action", null)
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
    ignore_changes = [
      iam_roles
    ]
  }

  tags = merge(var.tags, var.cluster_tags)
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  count = var.replica_scale_enabled ? var.replica_scale_min : var.replica_count

  identifier                      = "${var.name}-${count.index + 1}"
  cluster_identifier              = aws_rds_cluster.rds_cluster.id
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_type
  publicly_accessible             = false
  db_subnet_group_name            = local.db_subnet_group_name
  db_parameter_group_name         = aws_db_parameter_group.instance_param_grp.id
  preferred_maintenance_window    = var.preferred_maintenance_window
  apply_immediately               = var.apply_immediately
  monitoring_role_arn             = local.rds_enhanced_monitoring_arn
  monitoring_interval             = var.monitoring_interval
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  promotion_tier                  = count.index + 1
  performance_insights_enabled    = var.performance_insights_enabled
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  ca_cert_identifier              = var.ca_cert_identifier
  availability_zone               = var.availability_zone

  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }

  tags = var.tags
}

resource "aws_db_parameter_group" "instance_param_grp" {
  name        = "${var.name}-parameter-group"
  family      = var.family
  description = "aurora-db-parameter-group"

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

resource "aws_rds_cluster_parameter_group" "cluster_param_grp" {
  name        = "${var.name}-cluster-parameter-group"
  family      = var.family
  description = "aurora-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.cluster_parameter_group

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

resource "random_id" "snapshot_identifier" {
  keepers = {
    id = var.name
  }

  byte_length = 4
}

data "aws_iam_policy_document" "monitoring_rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "rds_enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  name               = "rds-enhanced-monitoring-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.monitoring_rds_assume_role.json

  permissions_boundary = var.permissions_boundary

  tags = merge(var.tags, {
    Name = local.name
  })
}

resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  count = var.monitoring_interval > 0 ? 1 : 0

  role       = local.rds_enhanced_monitoring_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_appautoscaling_target" "read_replica_count" {
  count = var.replica_scale_enabled ? 1 : 0

  max_capacity       = var.replica_scale_max
  min_capacity       = var.replica_scale_min
  resource_id        = "cluster:${aws_rds_cluster.rds_cluster.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"
}

resource "aws_appautoscaling_policy" "autoscaling_read_replica_count" {
  count = var.replica_scale_enabled ? 1 : 0

  name               = "target-metric"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "cluster:${aws_rds_cluster.rds_cluster.cluster_identifier}"
  scalable_dimension = "rds:cluster:ReadReplicaCount"
  service_namespace  = "rds"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }

    scale_in_cooldown  = var.replica_scale_in_cooldown
    scale_out_cooldown = var.replica_scale_out_cooldown
    target_value       = var.predefined_metric_type == "RDSReaderAverageCPUUtilization" ? var.replica_scale_cpu : var.replica_scale_connections
  }

  depends_on = [aws_appautoscaling_target.read_replica_count]
}
