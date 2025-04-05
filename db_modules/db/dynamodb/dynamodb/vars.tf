variable "app_name" {
  type = string
}

variable "environment" {
  type = string
}

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

variable "resource_tags" {
  description = "Tags to set for resources"
  type        = map(string)
  default = {
    terraform = "true"
  }
}

variable "required_tags" {
  description = "Tags required for resource"
  type        = map(string)
  default     = {}
}