provider "aws" {
  region = local.environment.source_region
  #profile = "aws-config-profile-alias" # If you deploy via CI/CD, this can remain commented out. However, for local deployments, uncomment and assign the name of your target aws alias in your .aws/config file
}

# I have not done much with the docdb module I use. So, for now, I just create the parameter group in the main.tf here
resource "aws_docdb_cluster_parameter_group" "docdbcluster_paramgp" {
  name   = "${local.environment.app_name_instance}-paramgp"
  family = "docdb5.0"

  parameter {
    name         = "tls"
    value        = "enabled"
    apply_method = "pending-reboot"
  }

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

# Module used to create the docdb cluster. Make sure your path for the source reflects your directory position
module "docdb" {
  source              = "path/to/your/modules/docdb"
  app_name            = local.environment.app_name
  environment         = local.environment.environment
  account             = local.environment.account
  database_name       = local.environment.database_name
  app_name_instance   = local.environment.app_name_instance
  docdbsecuritygp     = local.environment.docdbsecuritygp
  number_of_instances = local.environment.number_of_instances
  instance_class      = local.environment.instance_class
  parameter_group     = aws_docdb_cluster_parameter_group.docdbclusterparamgp.name
  kms_key_arn         = module.kmskey.key_arn
  deletion_protection = local.environment.deletion_protection
  maintenance_window  = local.environment.maintenance_window
  required_tags       = local.environment.required_tags
  resource_tags       = local.environment.resource_tags

  depends_on = [module.kmskey.key_arn]
}

# Outputs info on app name after deploy
output "account" {
  value = module.docdb.account
}

# Outputs info on docdb cluster endpoint after deploy. 
output "docdb_endpoint" {
  value = module.docdb.endpoint
}