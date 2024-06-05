variable "app_name_instance" {
  type        = string
  description = "The name of the application this database is being created for"
}

variable "account_number"{
  type = number
}

variable "iam_role" {
  type = string
}