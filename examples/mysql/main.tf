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


resource "aws_rds_cluster_parameter_group" "mysql8clusterparamgp" {
  name   = "${local.app_name_instance}-paramgp"
  family = "aurora-mysql8.0"

  parameter {
    name         = "aurora_binlog_replication_max_yield_seconds"
    value        = "0"
    apply_method = "immediate"
  }

  parameter {
    name         = "aurora_parallel_query"
    value        = "0"
    apply_method = "immediate"
  }

  parameter {
    name         = "binlog_format"
    value        = "ROW"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "connect_timeout"
    value        = "60"
    apply_method = "immediate"
  }

  parameter {
    name         = "enforce_gtid_consistency"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "explicit_defaults_for_timestamp"
    value        = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "general_log"
    value        = "0"
    apply_method = "immediate"
  }

  parameter {
    name         = "gtid-mode"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_adaptive_hash_index"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_adaptive_hash_index_parts"
    value        = "12"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "innodb_lock_wait_timeout"
    value        = "300"
    apply_method = "immediate"
  }

  parameter {
    name         = "innodb_purge_threads"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "key_buffer_size"
    value        = "115343360"
    apply_method = "immediate"
  }

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "long_query_time"
    value        = "600"
    apply_method = "immediate"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = "943718400"
    apply_method = "immediate"
  }

  parameter {
    name         = "max_heap_table_size"
    value        = "4294967296"
    apply_method = "immediate"
  }

  parameter {
    name         = "net_read_timeout"
    value        = "14400"
    apply_method = "immediate"
  }

  parameter {
    name         = "performance_schema"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_consumer_events_stages_current"
    value        = "0"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_consumer_events_statements_current"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_consumer_events_statements_history"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_consumer_events_statements_history_long"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance-schema-consumer-events-waits-current"
    value        = "ON"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_max_digest_length"
    value        = "50000"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "performance_schema_max_sql_text_length"
    value        = "50000"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "slow_query_log"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "sql_mode"
    value        = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION"
    apply_method = "immediate"
  }

  parameter {
    name         = "thread_cache_size"
    value        = "12"
    apply_method = "immediate"
  }

  parameter {
    name         = "tmp_table_size"
    value        = "1073741824"
    apply_method = "immediate"
  }


}

module "kmskey" {
  source            = "../../../terraform-modules/kms/kmskeys"
  app_name_instance = local.app_name_instance

}


module "mysql" {
  source              = "../../../terraform-modules/db/rds/mysql_spindown"
  app_name_instance   = local.app_name_instance
  kms_key_arn         = module.kmskey.key_arn
  number_of_instances = local.number_of_instances
  instance_class      = local.instance_class
  deletion_protection = local.deletetion_protection
  database_name       = local.database_name
  snapshot_identifier = local.snapshot_identifier
  param_grp           = aws_rds_cluster_parameter_group.mysql8clusterparamgp.name

}


output "account" {
  description = "Name of account"
  value       = local.account
}

output "app_name" {
  description = "Name of the instance"
  value       = local.app_name_instance
}

output "cluster_endpoint_writer" {
  description = "Writer endpoint"
  value       = module.mysql.cluster_endpoint_writer
}

output "cluster_endpoint_reader" {
  description = "Reader endpoint"
  value       = module.mysql.cluster_endpoint_reader
}
