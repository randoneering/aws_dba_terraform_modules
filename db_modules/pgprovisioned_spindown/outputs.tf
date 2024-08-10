output "account" {
  description = "Account"
  value       = var.account
}

output "app_name" {
  description = "Name of the instance"
  value       = var.app_name_instance
}

output "writer_endpoint" {
  value = aws_rds_cluster.pgprovisionedcluster.endpoint
}

output "reader_endpoint" {
  value = aws_rds_cluster.pgprovisionedcluster.reader_endpoint
}

