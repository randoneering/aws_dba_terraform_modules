output "account" {
  description = "Account"
  value       = var.account
}

output "app_name" {
  description = "Name of the instance"
  value       = var.app_name_instance
}

output "endpoint" {
  description = "endpoint"
  value       = aws_db_instance.msprovisionedinstance.endpoint
}

