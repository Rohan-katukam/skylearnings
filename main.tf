data "aws_caller_identity" "devops_account" {}
data "aws_region" "devops_account" {}

locals {
  account_id = data.aws_caller_identity.devops_account.account_id
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    sid = "Allow access for Account root"
    
    actions = [
      "kms:*",
    ]

    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${local.account_id}:root"]      
    }
  }

  statement {
    sid = "AllowUseOfTheKey"

    actions = [
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
      "kms:CancelKeyDeletion",
    ]

    resources = ["*"]
    principals {      
      type = "AWS"
      identifiers = tolist ([ for name in var.kms_admins: join("/", ["arn:aws:iam::${local.account_id}:user", "${name}"])])    
    }
  }
  statement {
    sid = "AllowKMStoCloudwatvhKey"    
    principals {
      type = "Service"
      identifiers = [
        format(
          "logs.%s.amazonaws.com",
          data.aws_region.devops_account.name
        )
      ]
    }

    actions = [
      "kms:Describe*",
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",      
    ]
    resources = ["*"]    
  }
}

resource "aws_kms_key" "kms_key" {
    description = "Secret Encryption Key"
    policy      = data.aws_iam_policy_document.kms_policy.json
    tags        = var.tags
}

resource "aws_kms_alias" "kms_key_alias" {
    name = var.kms_alias_name
    target_key_id = aws_kms_key.kms_key.key_id

    depends_on = [
        aws_kms_key.kms_key
    ]
    
}