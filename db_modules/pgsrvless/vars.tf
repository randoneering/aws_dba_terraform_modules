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
  default = "db.serverless"
}

variable "number_of_instances" {
  type    = number
  default = 1
}

variable "db_engine"{
  type = string
  default = "aurora-postgresql"
}

variable "pg_engine_version"{
  type = string
  default = "15.4"
}

variable "admin_username" {
  type = string
  default = "adminuser"
}
variable "engine_mode"{
  type = string
  default = "provisioned"
}
variable "serverless_max" {
  type    = number
  default = 5
}

variable "serverless_min" {
  type    = number
  default = ".5"
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

variable "pgsecuritygp" {
  type    = string
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