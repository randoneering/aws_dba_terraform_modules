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
  default = "db.t4g.medium"
}

variable "number_of_instances" {
  type    = number
  default = 1
}

variable "db_engine"{
  type = string
  default = "mysql"
}

variable "mysql_engine_version"{
  type = string
  default = "8.0.35"
}

variable "admin_username" {
  type = string
  default = "adminname"
}
variable "engine_mode"{
  type = string
  default = "provisioned"
}

variable "parameter_group" {
  type = string
}

variable "deletion_protection" {
  type    = string
  default = true
}

variable "kms_key_arn" {
  type = string
}

variable "database_name" {
  type = string
}

variable "rds_monitoring_role" {
  type    = string
  default = ""
}

variable "rds_monitoring_role_arn"{
  type = string
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

variable "mysqlsecuritygp" {
  type    = string
  default = ""
}

variable "snapshot_identifier"{
  type = string
  default = ""
}

variable "maintenance_window" {
  type = string
  default = "Sun:05:00-Sun:05:30"
}

variable "monitoring_window" {
  type = number
  default = 60
}