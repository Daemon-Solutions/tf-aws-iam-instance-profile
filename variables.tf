variable "name" { }
variable "ec2_describe" { default = "1" }
variable "ec2_attach" { default = "0" }
variable "s3_readonly" { default = "1" }
variable "rds_readonly" { default = "0" }
variable "cw_readonly" { default = "0" }
variable "cw_update" { default = "0" }
variable "r53_update" { default = "0" }
variable "redshift_read" { default = "0" }
variable "s3_write_buckets" { default = "" }
variable "sns_allowall" { default = "0" }
variable "sqs_allowall" { default = "0" }
variable "ssm_managed" { default = "0" }
variable "kms_decrypt" { default = "0" }
variable "kms_arns" { default = "" }