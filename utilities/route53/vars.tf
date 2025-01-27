variable "name" {
  type        = string
  description = "Name of the application"
  default     = ""
}

variable "route53zone" {
  type        = string
  description = "target route 53 hosted zone"
  default     = ""
}

variable "writer_endpoint" {
  type        = string
  description = "writer endpoint for rds instance"
  default     = ""
}

variable "reader_endpoint" {
  type        = string
  description = "reader endpoint for rds instance"
  default     = ""
}