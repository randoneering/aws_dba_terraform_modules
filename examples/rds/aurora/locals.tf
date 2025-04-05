locals {
  environment_configs = {
    deployment_branch = {
      account                         = ""                                                    # Account number to deploy to. 
      app_username                    = ""                                                    # Service username to create.
      name                            = ""                                                    # Name of service. Used in several modules/variables to populate names for associated resources.
      environment                     = ""                                                    # Name of environment to deploy to. 
      database_name                   = ""                                                    # Name of database.
      schema                          = ""                                                    # Relevant to Postgres. Leave blank if deploying to to DocumentDB, SQL Server, and MySQL.
      username                        = "masteruser"                                          # Master username
      engine_mode                     = "provisioned"                                         # I pick default engine mode as provisioned, even for serverless. Nothing should change here.
      engine                          = ""                                                    # Engine type. Options are aurora-postgresl, aurora-mysql.
      engine_version                  = ""                                                    # Engine version.
      family                          = ""                                                    # Parameter group family. Options for aurora are aurora-mysql8.0, aurora-postgresql#(aurora-postgresql16 for example).
      instance_type                   = "db.t4g.medium"                                       # Instance "class" or type for the cluster you are deploying. Default is in this template. Full list can be found here: https://aws.amazon.com/rds/instance-types/
      use_custom_reader_name          = false                                                 # Only needed if we have a specific use case to move away from normal naming convention created in route53 module (terraform-modules/route53/db).
      use_custom_writer_name          = false                                                 # Only needed if we have a specific use case to move away from normal naming convention created in route53 module (terraform-modules/route53/db).
      custom_reader_name              = ""                                                    # Enter custom reader name if needed, but leave default if "use_custom_reader_name" is "false"
      custom_writer_name              = ""                                                    # Enter custom writer name if needed, but leave default if "use_custom_writer_name" is "false"
      use_custom_cluster_identifier   = false                                                 # Only needed if a different name format is needed than the default.
      use_custom_instance_identifier  = false                                                 # Only needed if a different name format is needed than the default.
      custom_cluster_identifier       = ""                                                    # Enter custom cluster identifier if needed, but leave blank if "use_custom_cluster_identifier" is "false"
      custom_instance_identifier      = ""                                                    # Enter custom instance identifier if needed, but leave blank if "use_custom_instance_identifier" is "false"
      domain                          = ""                                                    # This will be the domain ID if you use kerberos authentication
      domain_iam_role_name            = ""                                                    # Role for allowing the database cluster/instance to communicate with AD
      dba_iam_role                    = ""                                                    # This is the role we all use to login to AWS Console (website). Easiest way to get this is login to an account, click on top right corner where your user is shown, and grab the value it shows.
      dba_iam_role_arn                = ""                                                    # Arn of above role.
      deletion_protection             = true                                                  # Enables deletion protection. Disable when you need to destroy the cluster.
      number_of_instances             = 1                                                     # Default is set to 1. If the cluster needs more or less nodes, change the number accordingly.
      source_region                   = "us-east-1"                                           # Default region to deploy to is us-east-1. 
      snapshot_identifier             = ""                                                    # If restoring from a snapshot, enter the arn here.
      enabled_cloudwatch_logs_exports = ["postgresql"]                                        # For postgres, the only log I enable is postgresql. For mysql, I enable "error", "slowquery", and "audit".
      rds_monitoring_role             = "rds-monitoring-role"                                 # Default per account, no need to change.
      rds_monitoring_role_arn         = "arn:aws:iam::ACCOUNTNUMBER:role/rds-monitoring-role" # Change account number to the account you are deploying to.
      vpc_security_group_ids          = [""]                                                  # This is the required security group to deploy the cluster with. I suggest created a security group for each engine.
      db_subnet_group_name            = ""                                                    # Specific to each account. Found in "subnets" under RDS console. I suggest creating one subnet for private subnets and another for public (if you plan on having your resource public facing)
      preferred_maintenance_window    = ""                                                    # Specific to each environment. 
      performance_insights_enabled    = "true"                                                # Always enable, default retention is 7 days for the free tier. 
      preferred_backup_window         = "03:00-05:00"                                         # Never change
      monitoring_interval             = 60                                                    # Default interval, free tier
      reader_needed                   = true                                                  # If reader endpoint is needed
      create_db_parameter_group       = false                                                 # Leave set to false unless a specific parameter group for an instance is needed. Cluster is typically enough.
      route53zone                     = "env.randoneering.tech"                               # Subject to change, but can be found in Route53 console in aws
      # The parameter group will be specific to the engine. Provided is the standard parameter set I use for postgres clusters. 
      cluster_parameter_group = [
        {
          name         = "ssl"
          value        = "true"
          apply_method = "pending-reboot"
        },
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
          }, {
          name         = "shared_preload_libraries"
          value        = "pg_stat_statements,pg_cron"
          apply_method = "pending-reboot"
        }
      ]
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