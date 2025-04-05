locals {
  environment_configs = {
    deployment_branch = {
      account                      = ""                                                                                                                              # Account number to deploy to. 
      app_username                 = ""                                                                                                                              # Service username to create. 
      name                         = ""                                                                                                                              # Name of service. Used in several modules/variables to populate names for associated resources.
      engine                       = "docdb"                                                                                                                         # Only value accepted here is docdb
      app_name                     = ""                                                                                                                              # Name of service. Used in several modules/variables to populate names for associated resources.
      app_name_instance            = ""                                                                                                                              # Name of service. Used in several modules/variables to populate names for associated resources.
      database_name                = ""                                                                                                                              # Name of database.
      preferred_maintenance_window = ""                                                                                                                              # Specific to each environment.
      backup_window                = "03:00-05:00"                                                                                                                   # Never change
      dba_iam_role                 = ""                                                                                                                              # This is the role we all use to login to AWS Console (website). Easiest way to get this is login to an account, click on top right corner where your user is shown, and grab the "AWSReservedSSO_DatabaseAdministrator_############" string.
      dba_iam_role_arn             = "arn:aws:iam::ACCOUNTNUMBER:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_DatabaseAdministrator_STRINGFROMSPECIFICACCOUNT" # Arn of above role. Make sure to enter correct account number.
      deletion_protection          = true                                                                                                                            # Enables deletion protection. Disable when you need to destroy the cluster.
      number_of_instances          = 1                                                                                                                               # Default is set to 1. If the cluster needs more or less nodes, change the number accordingly.
      instance_class               = "db.t3.medium"                                                                                                                  # Instance "class" or type for the cluster you are deploying. Default is in this template. Full list can be found here: https://aws.amazon.com/documentdb/pricing/
      source_region                = "us-east-1"                                                                                                                     # Default region to deploy to is us-east-1. 
      environment                  = ""                                                                                                                              # Name of environment to deploy to. 
      docdbsecuritygp              = ""                                                                                                                              # This is the required security group to deploy the cluster with. There is a security group for each engine, and specific to each acocunt and found in EC2 service in AWS Console. Search in security groups for "docdb_"
      service_user_uid             = ""                                                                                                                              # This will be the folder UID in keeper where the service account credential will be created. In keeper, got to environment-secrets > env > name-of-service > and click the "i" button on the folder details for uid
      required_tags = {
        terraform = "true" # Keep so we can know what resources are managed by terraform from a glance
        app       = ""     # Name of app/service database is supporting
        env       = ""     # Name of env to dpeloy to
      }
      resource_tags = {
        LightsOut = "True" #If you want to utilize my lightsout policy playbooks, I use this tag to decide if the instance/cluster is included in the policy
      }
    }
  }
  # Retrieve the environment-specific configuration based on the var.environment
  environment = local.environment_configs[terraform.workspace]
}

