variable "name" {
  description = "name of database/app for key"
  type        = string
  default     = ""
}

variable "key_owner_iam_role" {
  description = "iam role for key owner"
  type        = string
  default     = ""
}

variable "key_owner_iam_arn" {
  description = "arn for key_owner_iam_role"
  type        = string
  default     = ""
}

variable "resource_tags" {
  description = "tags for key resource"
  type        = map(string)
  default     = {}

}
variable "account" {
  description = "# for aws account"
  type        = string
  default     = ""
}