variable "app_name_instance" {
  type        = string
  description = "The name of the application this database is being created for"
}

variable "instance_class" {
  type    = string
  default = "db.r6g.xlarge"
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

# Creation of kms_key_arn can either happen in seperate module or in root/application folder.
variable "kms_key_arn" {
  type = string
}

variable "deletion_protection" {
  type    = string
  default = true

}