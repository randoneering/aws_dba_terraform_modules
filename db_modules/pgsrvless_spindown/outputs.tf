output "account" {
  description = "Account"
  value = var.account
}

output "app_name" {
  description = "Name of the instance"
  value       = var.app_name_instance
}
output "cluster_name" {
  description = "name of cluster"
  value       = aws_rds_cluster.pgsrvlesscluster.cluster_identifier
}

output "cluster_endpoint" {
  description = "cluster endpoint"
  value       = aws_rds_cluster.pgsrvlesscluster.endpoint
}
