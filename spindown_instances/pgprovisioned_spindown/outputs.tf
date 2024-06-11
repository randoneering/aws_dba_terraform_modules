output "cluster_endpoint_writer"{
    description = "Writer endpoint"
    value = aws_rds_cluster.pgprovisionedcluster.endpoint
}

output "cluster_endpoint_reader"{
    description = "Reader endpoint"
    value = aws_rds_cluster.pgprovisionedcluster.reader_endpoint
}

