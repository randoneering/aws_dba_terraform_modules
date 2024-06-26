# Variable for app name, used as an input in below module.
variable "app_name_instance" {
    type = string
    default = "mysql_spindown"
}

# Variable for account name-used for script to notify when resource is created or deleted in teams
variable "account_name"{
    type = string
    default = "########_accountname"
}


resource "aws_rds_cluster_parameter_group" "mysql8clusterparamgp" {
  name   = "${var.app_name_instance}-paramgp"
  family = "aurora-mysql8.0"


  parameter {
    name         = "aurora_parallel_query"
    value        = "0"
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
  source = "../../spindown_instances/mysql_spindown"
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