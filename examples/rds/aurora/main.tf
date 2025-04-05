provider "aws" {
  region = local.environment.source_region
  #profile = "aws-config-profile-alias" # If you deploy via CI/CD, this can remain commented out. However, for local deployments, uncomment and assign the name of your target aws alias in your .aws/config file

}


# Module used to create the necessary KMS key. Make sure your path for the source reflects your directory position
module "kmskey" {
  source           = "path/to/your/modules/dbakmskeys"
  name             = local.environment.name
  account          = local.environment.account
  environment      = local.environment.environment
  dba_iam_role     = local.environment.dba_iam_role
  dba_iam_role_arn = local.environment.dba_iam_role_arn
  required_tags    = local.environment.required_tags
  resource_tags    = local.environment.resource_tags
}

# Module used to create the aurora cluster. Make sure your path for the source reflects your directory position
module "aurora" {
  source                          = "path/to/your/modules/aurora"
  name                            = local.environment.name
  environment                     = local.environment.environment
  family                          = local.environment.family
  engine                          = local.environment.engine
  engine_version                  = local.environment.engine_version
  instance_type                   = local.environment.instance_type
  username                        = local.environment.username
  database_name                   = local.environment.database_name
  domain                          = local.environment.domain
  domain_iam_role_name            = local.environment.domain_iam_role_name
  deletion_protection             = local.environment.deletion_protection
  create_db_parameter_group       = local.environment.create_db_parameter_group
  kms_key_id                      = module.kmskey.key_arn
  cluster_parameter_group         = local.environment.cluster_parameter_group
  vpc_security_group_ids          = local.environment.vpc_security_group_ids
  enabled_cloudwatch_logs_exports = local.environment.enabled_cloudwatch_logs_exports
  preferred_maintenance_window    = local.environment.preferred_maintenance_window
  preferred_backup_window         = local.environment.preferred_backup_window
  monitoring_interval             = local.environment.monitoring_interval
  performance_insights_enabled    = local.environment.performance_insights_enabled
  db_subnet_group_name            = local.environment.db_subnet_group_name
  custom_cluster_identifier       = local.environment.custom_cluster_identifier
  custom_instance_identifier      = local.environment.custom_instance_identifier
  use_custom_cluster_identifier   = local.environment.use_custom_cluster_identifier
  use_custom_instance_identifier  = local.environment.use_custom_instance_identifier
  snapshot_identifier             = local.environment.snapshot_identifier
  required_tags                   = local.environment.required_tags
  resource_tags                   = local.environment.resource_tags

  depends_on = [module.kmskey.key_arn]
}

# Module used to create the Route53 dns records. Make sure your path for the source reflects your directory position
module "route53" {
  source                 = "path/to/your/modules/route53/"
  name                   = local.environment.name
  environment            = local.environment.environment
  reader_needed          = local.environment.reader_needed
  reader_endpoint        = module.aurora.rds_cluster_reader_endpoint
  writer_endpoint        = module.aurora.rds_cluster_endpoint
  route53zone            = local.environment.route53zone
  use_custom_reader_name = local.environment.use_custom_reader_name
  use_custom_writer_name = local.environment.use_custom_writer_name
  custom_writer_name     = local.environment.custom_writer_name
  custom_reader_name     = local.environment.custom_reader_name
}


# Outputs info on app name after deploy
output "app_name" {
  value = local.environment.name
}

# Outputs info about account number after deploy
output "account" {
  description = "Account Number"
  value       = local.environment.account
}

# Outputs dns record after deploy (writer)
output "writer_endpoint" {
  value = module.route53.dns_writer
}

# Outputs dns record after deploy (reader)
output "reader_endpoint" {
  value = module.route53.dns_reader
}