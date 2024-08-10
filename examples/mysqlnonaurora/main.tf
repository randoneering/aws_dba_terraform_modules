provider "aws" {
  region  = local.environment
  profile = "qa"

  default_tags {
    tags = {
      terraform    = "true"
      map-migrated = "migPE-Q0E02W4BGL"
    }
  }
}


resource "aws_db_parameter_group" "mysql8paramgp" {
  name   = "${local.app_name_instance}-paramgp"
  family = "mysql8.0"

  parameter {
    name         = "log_bin_trust_function_creators"
    value        = "1"
    apply_method = "immediate"
  }

  parameter {
    name         = "lower_case_table_names"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "max_allowed_packet"
    value        = "950000000"
    apply_method = "immediate"
  }

  parameter {
    name         = "tmp_table_size"
    value        = "170000000"
    apply_method = "immediate"
  }


}


module "kmskey" {
  account           = local.account
  source            = "../../../../terraform-modules/kms/dbakmskeys"
  app_name_instance = local.app_name_instance
  dba_iam_role      = local.dba_iam_role
  dba_iam_role_arn  = local.dba_iam_role_arn


}


module "mysql8_spindown" {
  account                 = local.account
  source                  = "../../../../terraform-modules/db/rds/mysql8_spindown"
  app_name_instance       = local.app_name_instance
  database_name           = local.database_name
  mysql_engine_version    = local.mysql_engine_version
  instance_class          = local.instance_class
  parameter_group         = aws_db_parameter_group.mysql8paramgp.id
  kms_key_arn             = module.kmskey.key_arn
  deletion_protection     = local.deletion_protection
  snapshot_identifier     = local.snapshot_identifier
  rds_monitoring_role     = local.rds_monitoring_role
  rds_monitoring_role_arn = local.rds_monitoring_role_arn
  database_subnetgp       = local.database_subnetgp
  dba_iam_role            = local.dba_iam_role
  mysqlsecuritygp         = local.mysqlsecuritygp

}

output "account" {
  description = "Account"
  value       = module.mysql8_spindown.account
}

output "app_name" {
  description = "Name of the instance"
  value       = module.mysql8_spindown.app_name
}

output "endpoint" {
  description = "endpoint"
  value       = module.mysql8_spindown.endpoint
}

