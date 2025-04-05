locals {
  alias = var.use_custom_alias ? "alias/${var.custom_kms_key_alias}" : "alias/${var.name}-${var.environment}-key"
}

resource "aws_kms_key" "rds_kms_key" {
  description = "KMS key specific to ${var.name}-${var.environment}"
  tags        = var.required_tags
}

resource "aws_kms_alias" "rds_kms_key_alias" {
  name          = local.alias
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
        "Resource" : "${aws_kms_key.rds_kms_key.arn}"
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
        "Resource" : "${aws_kms_key.rds_kms_key.arn}"
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
        "Resource" : "${aws_kms_key.rds_kms_key.arn}"
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
        "Resource" : "${aws_kms_key.rds_kms_key.arn}",
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