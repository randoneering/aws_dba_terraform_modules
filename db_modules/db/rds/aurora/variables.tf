variable "name" {
  description = "Name given resources"
  type        = string
}

variable "environment" {
  description = "The environment the resource is being deployed in (QA, PROD, STAGE, etc)"
}

variable "subnets" {
  description = "List of subnet IDs to use"
  type        = list(string)
  default     = []
}


variable "use_custom_cluster_identifier" {
  description = "Determine if a custom cluster name is needed from the default set in the main.tf of this module"
  type        = bool
  default     = false
}

variable "custom_cluster_identifier" {
  description = "To be used if there needs to be a specific, custom name for the cluster that differs from the default"
  type        = string
  default     = ""
}


variable "use_custom_instance_identifier" {
  description = "Determine if a custom instance name is needed from the default set in the main.tf of this module"
  type        = bool
  default     = false
}

variable "custom_instance_identifier" {
  description = "To be used if there needs to be a specific, custom name for the instance that differs from the default"
  type        = string
  default     = ""
}

variable "use_custom_cluster_param_name" {
  description = "Determine if a custom cluster param group name  is needed from the default set in the main.tf of this module"
  type        = bool
  default     = false
}

variable "custom_cluster_param_name" {
  description = "To be used if there needs to be a specific, custom name for the cluster param group that differs from the default"
  type        = string
  default     = ""
}


variable "use_custom_instance_param_name" {
  description = "Determine if a custom instance param group name is needed from the default set in the main.tf of this module"
  type        = bool
  default     = false
}

variable "custom_instance_param_name" {
  description = "To be used if there needs to be a specific, custom name for the instance param group that differs from the default"
  type        = string
  default     = ""
}



variable "replica_count" {
  description = "Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead."
  default     = 1
}


variable "instance_type" {
  description = "Instance type to use"
  type        = string
}


variable "database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "schmea" {
  description = "Schema to create"
  type        = string
  default     = ""
}
variable "username" {
  description = "Master DB username"
  type        = string
  default     = "root"
}

variable "password" {
  description = "Master DB password"
  type        = string
  default     = ""
}

variable "final_snapshot_identifier_prefix" {
  description = "The prefix name to use when creating a final snapshot on cluster destroy, appends a random 8 digits to name to ensure it's unique too."
  type        = string
  default     = "final"
}

variable "skip_final_snapshot" {
  description = "Should a final snapshot be created on cluster destroy"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "If the DB instance should have deletion protection enabled"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 14
}

variable "preferred_backup_window" {
  description = "When to perform DB backups"
  type        = string
  default     = "08:00-09:00"
}

variable "preferred_maintenance_window" {
  description = "When to perform DB maintenance"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "port" {
  description = "The port on which to accept connections"
  type        = string
  default     = ""
}

variable "apply_immediately" {
  description = "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  description = "The interval (seconds) between points when Enhanced Monitoring metrics are collected"
  type        = number
  default     = 60
}

variable "auto_minor_version_upgrade" {
  description = "Determines whether minor engine upgrades will be performed automatically in the maintenance window"
  type        = bool
  default     = true
}
variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = false
}


variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = null
}

variable "db_parameter_group" {
  description = "The name of a DB parameter group"
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default = []
}

variable "cluster_parameter_group" {
  description = "The name of a DB Cluster parameter group to use"
  type = list(object({
    apply_method = string
    name         = string
    value        = string
  }))
  default = []
}

variable "scaling_configuration" {
  description = "Map of nested attributes with scaling properties. Only valid when engine_mode is set to `serverless`"
  type        = map(string)
  default     = {}
}

variable "snapshot_identifier" {
  description = "DB snapshot to create this database from"
  type        = string
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the underlying storage layer should be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key if one is set to the cluster."
  type        = string
  default     = ""
}

variable "engine" {
  description = "Aurora database engine type, currently aurora, aurora-mysql or aurora-postgresql"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "Aurora database engine version."
  type        = string
  default     = ""
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "enable_http_endpoint" {
  description = "Whether or not to enable the Data API for a serverless Aurora database engine."
  type        = bool
  default     = false
}

variable "replica_scale_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora read replicas"
  type        = bool
  default     = false
}

variable "replica_scale_max" {
  description = "Maximum number of replicas to allow scaling for"
  type        = number
  default     = 3
}

variable "replica_scale_min" {
  description = "Minimum number of replicas to allow scaling for"
  type        = number
  default     = 1
}

variable "replica_scale_cpu" {
  description = "CPU usage to trigger autoscaling at"
  type        = number
  default     = 70
}

variable "replica_scale_connections" {
  description = "Average number of connections to trigger autoscaling at."
  type        = number
  default     = 700
}

variable "replica_scale_in_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale in"
  type        = number
  default     = 300
}

variable "replica_scale_out_cooldown" {
  description = "Cooldown in seconds before allowing further scaling operations after a scale out"
  type        = number
  default     = 300
}

variable "required_tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights is enabled or not."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data."
  type        = string
  default     = ""
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether IAM Database authentication should be enabled or not. Not all versions and instances are supported. Refer to the AWS documentation to see which versions are supported."
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to cloudwatch"
  type        = list(string)
  default     = [""]
}

variable "family" {
  description = "The family name of the RDS instance. See the RDS parameter group docs for complete list"
  type        = string
  default     = null
}

variable "global_cluster_identifier" {
  description = "The global cluster identifier specified on aws_rds_global_cluster"
  type        = string
  default     = null
}

variable "engine_mode" {
  description = "The database engine mode. Valid values: global, parallelquery, provisioned, serverless, multimaster."
  type        = string
  default     = "provisioned"
}

variable "replication_source_identifier" {
  description = "ARN of a source DB cluster or DB instance if this DB cluster is to be created as a Read Replica."
  default     = ""
}

variable "source_region" {
  description = "The source region for an encrypted replica DB cluster."
  default     = ""
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate to the cluster in addition to the SG we create in this module"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "The existing subnet group name to use"
  type        = string
  default     = ""
}

variable "predefined_metric_type" {
  description = "The metric type to scale on. Valid values are RDSReaderAverageCPUUtilization and RDSReaderAverageDatabaseConnections."
  default     = "RDSReaderAverageCPUUtilization"
}

variable "backtrack_window" {
  description = "The target backtrack window, in seconds. Only available for aurora engine currently. To disable backtracking, set this value to 0. Defaults to 0. Must be between 0 and 259200 (72 hours)"
  type        = number
  default     = 0
}

variable "copy_tags_to_snapshot" {
  description = "Copy all Cluster tags to snapshots."
  type        = bool
  default     = true
}

variable "iam_roles" {
  description = "A List of ARNs for the IAM roles to associate to the RDS Cluster."
  type        = list(string)
  default     = []
}


variable "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the role."
  type        = string
  default     = null
}

variable "ca_cert_identifier" {
  description = "The identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-ecc384-g1"
}

variable "availability_zone" {
  description = "List of AZ's cluster will be deployed in"
  type        = string
  default     = null
}


variable "resource_tags" {
  description = "A map of tags to add to only the RDS cluster. Used for AWS Instance Scheduler tagging"
  type        = map(string)
  default     = {}
}

variable "instances_parameters" {
  description = "Customized instance settings. Supported keys: `instance_name`, `instance_type`, `instance_promotion_tier`, `publicly_accessible`"
  type        = list(map(string))
  default     = []
}

variable "s3_import" {
  description = "Configuration map used to restore from S3"
  type        = map(string)
  default     = null
}


variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade on rds cluster"
  type        = bool
  default     = true
}
variable "domain" {
  description = "ID of the directory service in active directory domain to create cluster in. Usually used for kerberos auth"
  type        = string
  default     = ""
}

variable "domain_iam_role_name" {
  description = "Name of IAM role used when making API calls to the Directory Service"
  type        = string
  default     = ""
}