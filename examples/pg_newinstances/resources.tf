# Variable for app name, used as an input in below module.
variable "app_name_instance" {
    type = string
    default = "postgres_newinstance"
}


# Variable for account name-used for script to notify when resource is created or deleted in teams
variable "account_name"{
    type = string
    default = "########_accountname"
}



resource "aws_rds_cluster_parameter_group" "pg15clusterparamgp" {

  name   = "${var.app_name_instance}-paramgp"

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
  source = "../../utilities/kmskeys"
  app_name_instance = "${var.app_name_instance}"
  account_number = "123123124"
  iam_role = ""
  
}

module "mysql" {
  source = "../../new_instances/mysql"
  kms_key_arn = module.kmskey.key_arn
  app_name_instance = var.app_name_instance
  deletion_protection = true
  param_grp = aws_db_parameter_group.mysql8clusterparamgp.name
}


output "app_name" {
  value = var.app_name_instance
}

output "account_name" {
  value = var.account_name
}