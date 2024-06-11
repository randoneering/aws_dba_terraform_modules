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

variable "serverless_max" {
  type    = number
  default = "5"
}

variable "serverless_min" {
  type    = number
  default = ".5"
}

variable "parameter_group" {
  type = string
}

variable "deletion_protection" {
  type = string
}

variable "kms_key_arn" {
  type = string
}