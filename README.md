# cotiviti-terraform-core
- Intial Repo for Managing Terraform Code
- Added  KMS Module 
    Example to Create KMS Resource  

    ## Create KMS Key for EKS Cluster
        module "aws_kms" {
        source            = "../../modules/aws/aws_kms"
        kms_alias_name    = var.kms_alias_name
        kms_admins        = var.kms_admins
        tags              = "${merge(var.tags,tomap({"Name" = "Ronin-app1"}))}" 
        }