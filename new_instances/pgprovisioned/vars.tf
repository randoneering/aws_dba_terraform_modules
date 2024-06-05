# Technically, this variable is used to identify the name of the application. Input comes from the application folder. 
variable "app_name_instance" {
  type        = string
  description = "The name of the application this database is being created for"
}

# Set this default to your likings
variable "instance_class" {
  type    = string
  default = "db.t4g.medium"
}

# Straightforward-variable for number of instances to create. Default is 1
variable "number_of_instances" {
  type    = number
  default = 1
}

# Creation of parameter group happens in root/application folder. 
variable "parameter_group" {
  type = string
}

variable "deletion_protection" {
  type = string
}

variable "kms_key_arn" {
  type = string
}