locals {
  account                 = ""
  app_name_instance       = ""
  database_name           = ""
  mysql_engine_version    = "8.0.35"
  dba_iam_role            = ""
  dba_iam_role_arn        = ""
  deletion_protection     = true
  number_of_instances     = 1
  instance_class          = "db.t4g.large"
  environment             = ""
  snapshot_identifier     = ""
  rds_monitoring_role     = ""
  rds_monitoring_role_arn = ""
  mysqlsecuritygp         = ""
  database_subnetgp       = ""
}