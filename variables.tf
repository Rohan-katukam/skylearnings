variable "kms_alias_name" {
  description = "KMS Key alias Name"
  type  = string
  default = ""  
}

variable "kms_admins" {
  description = "name of the IAM roles to assume KMS admin privilege"  
}

variable "tags" {
    description = "A map of tags to use on all resources"
    type = map(string)
    default = {}
}