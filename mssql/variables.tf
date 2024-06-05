# Technically, this variable is used to identify the name of the application. Input comes from the application folder. 
variable "app_name_instance" {
  type        = string
  description = "The name of the application this database is being created for"
}

# Set this default to your likings
variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}

# Creation of parameter group happens in root/application folder. 
variable "parameter_group" {
  type = string
}

variable "deletion_protection" {
  type = string
}

# Adjust to your liking
variable "allocated_storage" {
  type    = string
  default = 50
}

# Key arn
variable "kms_key_arn" {
  type = string
}