provider "aws" {
  region  = local.region
  profile = "env"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

resource "aws_docdb_cluster_parameter_group" "docdbclusterparamgp" {
  name   = "${local.name}-paramgp"
  family = "docdb5.0"

  parameter {
    name         = "tls"
    value        = "enabled"
    apply_method = "pending-reboot"
  }

}

module "kmskey" {
  source             = "../../utilities/kmskeys"
  name               = local.name
  account            = local.account
  key_owner_iam_arn  = local.key_owner_iam_arn
  key_owner_iam_role = local.key_owner_iam_role

}


module "docdb" {
  source              = "../../db_modules/docdb"
  account             = local.account
  database_name       = local.database_name
  name                = local.name
  security_group      = local.security_group
  number_of_instances = local.number_of_instances
  instance_class      = local.instance_class
  parameter_group     = aws_docdb_cluster_parameter_group.docdbclusterparamgp.name
  kms_key_arn         = module.kmskey.key_arn
  deletion_protection = local.deletion_protection
}


output "account" {
  value = module.docdb.account
}

output "docdb_arn" {
  value = module.docdb.instance_arn
}

output "docb_endpoint" {
  value = module.docdb.endpoint
}