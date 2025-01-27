provider "aws" {
  region  = "us-east-1"
  profile = "example"
}


module "aurora" {

  source                          = "../db_modules/rds/aurora"
  name                            = local.name
  engine                          = local.engine
  deletion_protection             = local.deletion_protection
  family                          = local.family
  instance_type                   = local.instance_type
  enabled_cloudwatch_logs_exports = local.cloudwatch_logs
  replica_count                   = local.replica_count
  vpc_id                          = local.vpc_id
  db_subnet_group_name            = local.subnet_group_name
  vpc_security_group_ids          = local.security_group_ids
  preferred_maintenance_window    = local.maintenance_window
  snapshot_identifier             = local.snapshot_identifier
  kms_key_id                      = module.kms_key.key_arn
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
    }
  ]
  cluster_tags = {
    app = "example"
    env = "example"
  }
  tags = {
    owner     = "justin@randoneering.tech"
    terraform = "true"
  }

}

module "kms_key" {
  source             = "../../utilities/kmskeys"
  name               = local.name
  account            = local.account
  key_owner_iam_arn  = local.key_owner_iam_arn
  key_owner_iam_role = local.key_owner_iam_role
}

module "route_53" {
  source          = "../../utilities/route53"
  name            = local.name
  route53zone     = local.route53zone
  writer_endpoint = module.aurora_rxb.this_rds_cluster_endpoint
  reader_endpoint = module.aurora_rxb.this_rds_cluster_reader_endpoint
}

