variable "account" {
  type    = string
  default = ""
}

variable "app_name_instance" {
  type        = string
  description = "The name of the application this database is being created for"
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "parameter_group" {
  type = string
}

variable "deletion_protection" {
  type = string
}

variable "allocated_storage" {
  type    = string
  default = 50
}

variable "storage_type" {
  type    = string
  default = "gp3"
}

variable "kms_key_arn" {
  type = string
}

variable "rds_monitoring_role" {
  type    = string
  default = ""
}


variable "number_of_instances" {
  type    = number
  default = 1
}

variable "db_engine" {
  type    = string
  default = "sqlserver-web"
}

variable "mssql_engine_version" {
  type    = string
  default = "15.00.4365.2.v1"
}

variable "admin_username" {
  type    = string
  default = "adminname"
}
variable "engine_mode" {
  type    = string
  default = "provisioned"
}

variable "database_name" {
  type    = string
  default = ""
}

variable "rds_monitoring_role_arn" {
  type    = string
  default = ""

}
variable "database_subnetgp" {
  type    = string
  default = ""
}

variable "dba_iam_role" {
  type    = string
  default = ""
}

variable "mssqlsecuritygp" {
  type    = string
  default = ""
}

variable "maintenance_window" {
  type    = string
  default = "Sun:05:00-Sun:05:30"
}

variable "monitoring_window" {
  type    = number
  default = 60
}