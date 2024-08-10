variable "app_name_instance" {
  type = string
}

variable "dba_iam_role" {
  type    = string
  default = ""
}

variable "dba_iam_role_arn" {
    type = string
    default =""
}

variable "account" {
  type    = string
  default = ""
}