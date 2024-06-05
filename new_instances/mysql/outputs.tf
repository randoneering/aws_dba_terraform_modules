output "cluster_endpoint_writer" {
  description = "Writer endpoint"
  value       = aws_rds_cluster.msprovisionedcluster.endpoint
}

output "cluster_endpoint_reader" {
  description = "Reader endpoint"
  value       = aws_rds_cluster.msprovisionedcluster.reader_endpoint
}

