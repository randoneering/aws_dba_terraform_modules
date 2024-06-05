output "cluster_name" {
  description = "name of cluster"
  value       = aws_rds_cluster.pgsrvlesscluster.cluster_identifier
}

output "cluster_endpoint" {
  description = "cluster endpoint"
  value       = aws_rds_cluster.pgsrvlesscluster.endpoint
}
