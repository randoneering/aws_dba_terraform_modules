output "table_name" {
  value = aws_dynamodb_table.tf_lock_table.name
}

output "table_arn" {
  value = aws_dynamodb_table.tf_lock_table.arn
}