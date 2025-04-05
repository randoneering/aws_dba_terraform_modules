variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "enable_lifecycle" {
  description = "Enable lifecycle rule for the S3 bucket"
  type        = bool
  default     = false
}
variable "lifecycle_rule" {
  description = "Lifecycle rule configuration"
  type = object({
    id              = string
    status          = string
    transition_days = number
    storage_class   = string
    expiration_days = number
  })
  default = {
    id              = "archive-events"
    status          = "Enabled"
    transition_days = 30
    storage_class   = "DEEP_ARCHIVE"
    expiration_days = 180
  }
}