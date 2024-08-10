provider "aws" {
  region  = local.environment
  profile = "env"

  default_tags {
    tags = {
      terraform    = "true"
      map-migrated = "migPE-Q0E02W4BGL"
    }
  }
}

resource "aws_rds_cluster_parameter_group" "pg15clusterparamgp" {
  name   = "${local.app_name_instance}-paramgp"
  family = "aurora-postgresql15"

  parameter {
    name         = "autovacuum"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "autovacuum_analyze_threshold"
    value        = "0"
    apply_method = "immediate"
  }

  parameter {
    name         = "autovacuum_naptime"
    value        = "15"
    apply_method = "immediate"
  }

  parameter {
    name         = "autovacuum_vacuum_cost_delay"
    value        = "20"
    apply_method = "immediate"
  }

  parameter {
    name         = "autovacuum_vacuum_scale_factor"
    value        = "0.5"
    apply_method = "immediate"
  }

  parameter {
    name         = "autovacuum_vacuum_threshold"
    value        = "50"
    apply_method = "immediate"
  }

  parameter {
    name         = "pg_stat_statements.max"
    value        = "50000"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "pg_stat_statements.track"
    value        = "ALL"
    apply_method = "immediate"
  }

  parameter {
    name         = "pg_stat_statements.track_utility"
    value        = "0"
    apply_method = "immediate"
  }

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "rds.logical_replication"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pg_ad_mapping,pg_stat_statements"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "track_activity_query_size"
    value        = "50000"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "track_counts"
    value        = "1"
    apply_method = "immediate"
  }
}

module "kmskey" {
  source            = "../../../terraform-modules/kms/kmskeys"
  app_name_instance = local.app_name_instance

}

module "pgsrvless" {
  source              = "../../../terraform-modules/db/pgsrvless"
  app_name_instance   = local.app_name_instance
  kms_key_arn         = module.kmskey.key_arn
  serverless_max      = 2
  database_name       = local.database_name
  deletion_protection = true
  parameter_group     = aws_rds_cluster_parameter_group.pg15clusterparamgp.name
}

output "app_name" {
  value = local.app_name_instance
}

output "account" {
  description = "Account Number"
  value       = local.account
}
output "cluster_name" {
  value = module.pgsrvless.cluster_name
}

output "writer_endpoint" {
  value = module.pgsrvless.cluster_endpoint

}