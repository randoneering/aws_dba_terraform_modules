locals {
  environment_configs = {
    deployment_branch = {
      account                         = ""                                                                                                                              # Account number to deploy to. 
      name                            = ""                                                                                                                              # Name of service. Used in several modules/variables to populate names for associated resources.
      number_of_instances             = 1                                                                                                                               # Default is set to 1. Typically, if a cluster is needed, you should deploy resource with aurora module instead.
      database_name                   = ""                                                                                                                              # Name of database.
      environment                     = ""                                                                                                                              # Name of environment to deploy to. 
      family                          = ""                                                                                                                              # Parameter group family. Options are mysql8.0, postgres# (postgres16), sqlserver-EDITION-VERSION (sqlserver-se-15.0) 
      use_custom_writer_name          = false                                                                                                                           # Only needed if you have a specific use case to move away from normal naming convention created in route53 module (terraform-modules/route53/db).
      custom_writer_name              = ""                                                                                                                              # Enter custom writer name if needed, but leave default if "use_custom_writer_name" is "false"
      use_custom_instance_identifier  = false                                                                                                                           # Only needed if a different name format is needed than the default.
      custom_instance_identifier      = ""                                                                                                                              # Enter custom instance identifier if needed, but leave blank if "use_custom_instance_identifier" is "false"
      source_region                   = ""                                                                                                                              # Default region to deploy to is us-east-1. 
      domain                          = ""                                                                                                                              # This will be the domain ID if you use kerberos authentication
      domain_iam_role_name            = ""                                                                                                                              # Role for allowing the database cluster/instance to communicate with AD
      username                        = "rxadmin"                                                                                                                       # Master username
      engine                          = ""                                                                                                                              # Engine type. Options we support are mysql, postgres, sqlserver-(ee, se, ex, or web)
      engine_version                  = ""                                                                                                                              # Engine version.
      engine_mode                     = "provisioned"                                                                                                                   # I set this to provisioned, even for serverless. Nothing should change here.
      enabled_cloudwatch_logs_exports = [""]                                                                                                                            # For postgres, the only log I enable is postgresql. For mysql, I enable "error", "slowquery", and "audit".
      storage_type                    = "gp3"                                                                                                                           # This is the storage type version to use for nonaurora instances. 
      allocated_storage               = 60                                                                                                                              # The allocated amount of storage will be the amount of storage the instance has in total. To increase the amount, just change the number and apply.
      max_allocated_storage           = null                                                                                                                            # Only set if you want to enable storage auto-scaling. By default, I leave this off. 
      iops                            = 3000                                                                                                                            # Default iops to use. Increase as necessary.
      dba_iam_role                    = "AWSReservedSSO_DatabaseAdministrator_STRINGFROMSPECIFICACCOUNT"                                                                # This is the role you use to login to AWS Console (website). Easiest way to get this is login to an account, click on top right corner where your user is shown, and grab the value it shows.
      dba_iam_role_arn                = "arn:aws:iam::ACCOUNTNUMBER:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_DatabaseAdministrator_STRINGFROMSPECIFICACCOUNT" # Arn of above role. Make sure to enter correct account number.
      deletion_protection             = true                                                                                                                            # Enables deletion protection. Disable when you need to destroy the cluster.
      instance_class                  = "db.t4g.large"                                                                                                                  # Instance "class" or type for the cluster you are deploying. Default is in this template. Full list can be found here: https://aws.amazon.com/rds/instance-types/
      snapshot_identifier             = ""                                                                                                                              # If restoring from a snapshot, enter the arn here.
      rds_monitoring_role             = "rds-monitoring-role"                                                                                                           # Default per account, no need to change.
      rds_monitoring_role_arn         = "arn:aws:iam::ACCOUNTNUMBER:role/rds-monitoring-role"                                                                           # Change account number to the account you are deploying to.
      vpc_security_group_ids          = [""]                                                                                                                            # This is the required security group to deploy the cluster with. I suggest created a security group for each engine.
      db_subnet_group_name            = ""                                                                                                                              # Specific to each account. Found in "subnets" under RDS console. I suggest creating one subnet for private subnets and another for public (if you plan on having your resource public facing)
      preferred_maintenance_window    = ""                                                                                                                              # Specific to each environment.
      performance_insights_enabled    = "true"                                                                                                                          # Always enable, default retention is 7 days for the free tier. 
      preferred_backup_window         = "03:00-05:00"                                                                                                                   # Never change
      monitoring_interval             = 60                                                                                                                              # Default interval, free tier
      route53zone                     = "env.rxbenefits.cloud"                                                                                                          # Subject to change, but can be found in Route53 console in aws
      reader_needed                   = false                                                                                                                           # If reader endpoint is needed
      # The parameter group will be specific to the engine. Provided is the standard parameter group for postgres instances that I use                                                                                                                       
      db_parameter_group = [
        {
          name         = "autovacuum"
          value        = "1"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_analyze_threshold"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_naptime"
          value        = "15"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_vacuum_cost_delay"
          value        = "20"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_vacuum_scale_factor"
          value        = "0.5"
          apply_method = "immediate"
        },
        {
          name         = "autovacuum_vacuum_threshold"
          value        = "50"
          apply_method = "immediate"
        },
        {
          name         = "pg_stat_statements.max"
          value        = "50000"
          apply_method = "pending-reboot"
        },
        {
          name         = "pg_stat_statements.track"
          value        = "ALL"
          apply_method = "immediate"
        },
        {
          name         = "pg_stat_statements.track_utility"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "rds.force_ssl"
          value        = "0"
          apply_method = "immediate"
        },
        {
          name         = "rds.logical_replication"
          value        = "1"
          apply_method = "pending-reboot"
        },
        {
          name         = "shared_preload_libraries"
          value        = "pg_stat_statements,pg_cron"
          apply_method = "pending-reboot"
        },
        {
          name         = "track_activity_query_size"
          value        = "50000"
          apply_method = "pending-reboot"
        },
        {
          name         = "track_counts"
          value        = "1"
          apply_method = "immediate"
        }
      ]
      required_tags = {
        terraform = "true" # Keep so we can know what resources are managed by terraform from a glance
        app       = ""     # Name of app/service database is supporting
        env       = ""     # Name of env to dpeloy to
      }
      resource_tags = {
        LightsOut = "True" # If you want to utilize my lightsout policy playbooks, I use this tag to decide if the instance/cluster is included in the policy
      }
    }
  }
  # Retrieve the environment-specific configuration based on the var.environment
  environment = local.environment_configs[terraform.workspace]
}