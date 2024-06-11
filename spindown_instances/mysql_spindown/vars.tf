
variable "app_name_instance" {
  type        = string
  description = "The name of the application this database is being created for"
}

variable "instance_class" {
  type    = string
  default = "db.t4g.medium"
}

variable "number_of_instances" {
  type = number
  default = 1
}

variable "deletion_protection"{
  type = string
  default = true
}

variable "kms_key_arn" {
  type = string
}


variable "param_grp" {
  type = string
  default = "aws_rds_cluster_parameter_group.paramgp"
}