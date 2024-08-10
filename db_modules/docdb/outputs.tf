output "account" {
  value = var.account
}

output "app_name" {
  description = "Name of the instance"
  value       = var.app_name_instance
}

output "endpoint" {
  value = aws_docdb_cluster.docdb.endpoint
}

output "instance_arn" {
  value = aws_docdb_cluster.docdb.arn
}