provider "aws" {
  region = local.environment
  profile = "env"

  default_tags {
    tags = {
      terraform    = "true"
      map-migrated = "migPE-Q0E02W4BGL"
    }
  }
}

resource "aws_docdb_cluster_parameter_group" "docdbclusterparamgp" {
  name   = "${local.app_name_instance}-paramgp"
  family = "docdb5.0"

  parameter {
    name         = "tls"
    value        = "enabled"
    apply_method = "pending-reboot"
  }

}

module "kmskey" {
  source = "../../../../terraform-modules/kms/dbakmskeys"
  app_name_instance = "${local.app_name_instance}"
  account = local.account
  dba_iam_role = local.dba_iam_role
  dba_iam_role_arn = local.dba_iam_role_arn
  
}


module "docdb" {
  source              = "../../../../terraform-modules/db/documentdb/docdb"
  account = local.account
  database_name = local.database_name
  app_name_instance   = local.app_name_instance
  docdbsecuritygp = local.docdbsecuritygp
  number_of_instances = local.number_of_instances
  instance_class      = local.instance_class
  parameter_group = aws_docdb_cluster_parameter_group.docdbclusterparamgp.name
  kms_key_arn = module.kmskey.key_arn
  deletion_protection = local.deletion_protection
}


output "account"{
  value = module.docdb.account
}

output "docdb_arn" {
  value = module.docdb.instance_arn
}

output "docb_endpoint" {
  value = module.docdb.endpoint
}