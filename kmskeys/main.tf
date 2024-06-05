
# Creating the KMS key for the database cluster. Each cluster will have its own KMS key. 
# The var.app_name_instance is a variable you can find in the main.tf of the application folder.
resource "aws_kms_key" "rds_kms_key" {
  description = "KMS key specific to ${var.app_name_instance}"


}

# Simply creating the KMS key does not assign it with an alias. An alias is required, and thus,
# we are creating that here. 
resource "aws_kms_alias" "rds_kms_key_alias" {
  name          = "alias/${var.app_name_instance}-key"
  target_key_id = aws_kms_key.rds_kms_key.id
}

# This resource creates and applies the standard DBA KMS policy to allow the 
# iam role to manage the key
resource "aws_kms_key_policy" "rds_kms_key_dba_policy" {
  key_id = aws_kms_key.rds_kms_key.id
  policy = jsonencode({
    "Id" : "dba_kms_grant_policy",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.account_number}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${var.account_number}:role/aws-reserved/sso.amazonaws.com/${var.iam_role}"

          ]
        },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow use of the key",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${var.account_number}:role/aws-reserved/sso.amazonaws.com/${var.iam_role}"
          ]
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "Allow attachment of persistent resources",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::${var.account_number}:role/aws-reserved/sso.amazonaws.com/${var.iam_role}"
          ]
        },
        "Action" : [
          "kms:CreateGrant*",
          "kms:ListGrants*",
          "kms:RevokeGrant*"
        ],
        "Resource" : "*",
        "Condition" : {
          "Bool" : {
            "kms:GrantIsForAWSResource" : "true"
          }
        }
      }
    ]















  })


}


# Finally, the last piece of the KMS key is allowing the dba_iam_role above to
# Encrypt and Decrypt snapshots/backups from this instance. 
resource "aws_kms_grant" "rds_kms_key_grant" {
  name              = "DBA-KMS-Grant"
  key_id            = aws_kms_key.rds_kms_key.id
  grantee_principal = data.aws_iam_role.dba_iam_role.arn
  operations        = ["Encrypt", "Decrypt"]

}
