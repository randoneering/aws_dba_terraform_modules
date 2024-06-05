output "cluster_endpoint_writer" {
    value = aws_rds_cluster.pgprovisionedcluster.endpoint
}

output "cluster_endpoint_reader" {
    value = aws_rds_cluster.pgprovisionedcluster.reader_endpoint
}