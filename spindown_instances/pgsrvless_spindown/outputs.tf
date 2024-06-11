
output "cluster_reader" {
  value = aws_rds_cluster.pgsrvlesscluster.reader_endpoint
}

output "cluster_writer" {
  value       = aws_rds_cluster.pgsrvlesscluster.endpoint
}

