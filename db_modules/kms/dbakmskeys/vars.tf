
variable "name" {
  description = "Name of application/service the db is supporting."
  type        = string
  default     = ""
}

variable "environment" {
  description = "The environment you are deploying to. For the related modules in this repo, I am using workspaces to switch between environments to deploy to."
  type        = string
  default     = ""
}

variable "dba_iam_role" {
  description = "Typically the role you are assigned, in AWS, when you login to console. Or this can be a role that you like to use for automated tasks"
  type        = string
  default     = ""
}

variable "dba_iam_role_arn" {
  description = "Arn for the above role"
  type        = string
  default     = ""
}

variable "account" {
  description = "Account to deploy to"
  type        = string
  default     = ""
}

variable "use_custom_alias" {
  type        = bool
  description = "Use this if you need to create a new kms key when there is already one with a similiar name, or you simply need to make a custom name for the kms key other than our default"
  default     = false
}

variable "custom_kms_key_alias" {
  type        = string
  description = "Use this if you need to create a new kms key when there is already one with a similiar name, or you simply need to make a custom name for the kms key other than our default"
  default     = ""
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