output "account" {
  value = var.account
}

output "key_arn" {
  value = aws_kms_key.rds_kms_key.arn
}
