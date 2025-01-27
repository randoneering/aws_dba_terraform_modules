resource "aws_dynamodb_table" "tf_lock_table" {
  name                        = var.table_name
  billing_mode                = var.billing_mode
  read_capacity               = var.read_cap
  write_capacity              = var.write_cap
  hash_key                    = var.hash_key
  deletion_protection_enabled = var.deletetion_protection
  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    yourtags : "here"
  }
}