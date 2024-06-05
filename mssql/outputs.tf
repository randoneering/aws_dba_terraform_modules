output "mssql_endpoint" {
  value = aws_db_instance.sqlsvrinstance.endpoint
}

output "mssql_arn" {
  value = aws_db_instance.sqlsvrinstance.arn
}
