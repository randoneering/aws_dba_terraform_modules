output "account" {
  description = "Account"
  value = var.account
}

output "app_name" {
  description = "Name of the instance"
  value       = var.app_name_instance
}
output "cluster_endpoint_writer" {
  description = "Writer endpoint"
  value       = aws_rds_cluster.msprovisionedcluster.endpoint
}

output "cluster_endpoint_reader" {
  description = "Reader endpoint"
  value       = aws_rds_cluster.msprovisionedcluster.reader_endpoint
}

