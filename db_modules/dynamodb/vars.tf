variable "table_name" {
  type    = string
  default = ""
}

variable "write_cap" {
  type    = number
  default = 5
}

variable "read_cap" {
  type    = number
  default = 5
}

variable "billing_mode" {
  type    = string
  default = "PROVISIONED"
}

variable "hash_key" {
  type    = string
  default = ""

}

variable "deletetion_protection" {
  type    = string
  default = true
}