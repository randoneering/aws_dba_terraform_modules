output "key_arn" {
  description = "KMS Key Arn"
  value       = aws_kms_key.rds_kms_key.arn
}
output "kms_key_id" {
  description = "ID for KMS key"
  value       = aws_kms_key.rds_kms_key.id
}

output "app_name" {
  description = "Name of the instance"
  value       = var.name
}