resource "aws_kms_key" "rds_kms_key" {
  description = "KMS key specific to ${var.app_name_instance}"
}

resource "aws_kms_alias" "rds_kms_key_alias" {
  name          = "alias/${var.app_name_instance}-key"
  target_key_id = aws_kms_key.rds_kms_key.id
}

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
          "AWS" : "arn:aws:iam::${var.account}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow access for Key Administrators",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "${var.dba_iam_role_arn}"

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
            "${var.dba_iam_role_arn}"
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
            "${var.dba_iam_role_arn}"
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

resource "aws_kms_grant" "rds_kms_key_grant" {
  name              = "DBA-KMS-Grant"
  key_id            = aws_kms_key.rds_kms_key.id
  grantee_principal = var.dba_iam_role_arn
  operations        = ["Encrypt", "Decrypt"]
}