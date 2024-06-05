variable "table_name" {
  type = string
}

variable "write_cap" {
  type    = number
  default = 5
}

variable "read_cap" {
  type    = number
  default = 5
}