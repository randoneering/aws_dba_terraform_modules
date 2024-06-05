resource "aws_dynamodb_table" "tf_lock_table" {
  name                        = var.table_name
  billing_mode                = "PROVISIONED"
  read_capacity               = var.read_cap
  write_capacity              = var.write_cap
  hash_key                    = "LockID"
  deletion_protection_enabled = true
  point_in_time_recovery {
    enabled = true
  }

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Backup : "RDS"
    env : "appdev"
    EnforceAutomaticeScale : "False"
    map-migrated : "migPE-Q0E02W4BGL"
    owner : "dba@rxbenefits.com"
  }
}