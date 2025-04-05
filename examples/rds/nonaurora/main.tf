provider "aws" {
  region = local.environment.source_region
  #profile = "aws-config-profile-alias" # If you deploy via CI/CD, this can remain commented out. However, for local deployments, uncomment and assign the name of your target aws alias in your .aws/config file
}

# Module used to create the necessary KMS key. Make sure your path for the source reflects your directory position
module "kmskey" {
  source           = "path/to/your/modules/dbakmskeys"
  name             = local.environment.name
  environment      = local.environment.environment
  account          = local.environment.account
  dba_iam_role     = local.environment.dba_iam_role
  dba_iam_role_arn = local.environment.dba_iam_role_arn
  required_tags    = local.environment.required_tags
  resource_tags    = local.environment.resource_tags
}

# Module used to create the rds instance. I have not set up this module to officially allow creating clusters. This is something I rarely run into, but can make adjustments to allow this if needed. Make sure your path for the source reflects your directory position
module "nonaurora" {
  source                                = "path/to/your/modules/nonaurora"
  account                               = local.environment.account
  name                                  = local.environment.name
  username                              = local.environment.username
  environment                           = local.environment.environment
  engine                                = local.environment.engine
  engine_version                        = local.environment.engine_version
  domain                                = local.environment.domain
  domain_iam_role_name                  = local.environment.domain_iam_role_name
  family                                = local.environment.family
  enabled_cloudwatch_logs_exports       = local.environment.enabled_cloudwatch_logs_exports
  db_subnet_group_name                  = local.environment.db_subnet_group_name
  instance_class                        = local.environment.instance_class
  iops                                  = local.environment.iops
  preferred_backup_window               = local.environment.preferred_backup_window
  kms_key_id                            = module.kmskey.key_arn
  deletion_protection                   = local.environment.deletion_protection
  db_parameter_group                    = local.environment.db_parameter_group
  vpc_security_group_ids                = local.environment.vpc_security_group_ids
  monitoring_interval                   = local.environment.monitoring_interval
  performance_insights_enabled          = local.environment.performance_insights_enabled
  performance_insights_retention_period = local.environment.performance_insights_retention_period
  allocated_storage                     = local.environment.allocated_storage
  max_allocated_storage                 = local.environment.max_allocated_storage
  storage_type                          = local.environment.storage_type
  preferred_maintenance_window          = local.environment.preferred_maintenance_window
  snapshot_identifier                   = local.environment.snapshot_identifier
  use_custom_instance_identifier        = local.environment.use_custom_instance_identifier
  custom_instance_identifier            = local.environment.custom_instance_identifier
  required_tags                         = local.environment.required_tags
  resource_tags                         = local.environment.resource_tags

  depends_on = [module.kmskey.key_arn]
}

# Module used to create the Route53 dns records. Make sure your path for the source reflects your directory position
module "route53" {
  source                 = "path/to/your/modules/route53"
  name                   = local.environment.name
  environment            = local.environment.environment
  writer_endpoint        = module.nonaurora.rds_instance_endpoint
  reader_needed          = local.environment.reader_needed
  route53zone            = local.environment.route53zone
  use_custom_writer_name = local.environment.use_custom_writer_name
  custom_writer_name     = local.environment.custom_writer_name
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