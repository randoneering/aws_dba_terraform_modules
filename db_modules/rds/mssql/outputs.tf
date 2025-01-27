output "app_name" {
  description = "Name of the instance"
  value       = var.app_name_instance
}

output "account" {
  value = var.account
}
output "instance_endpoint" {
  value = aws_db_instance.sqlsvrinstance.endpoint
}

output "instance_arn" {
  value = aws_db_instance.sqlsvrinstance.arn
}

