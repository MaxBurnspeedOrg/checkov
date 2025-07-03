provider "aws" {
  region = "us-east-1"
}


resource "aws_s3_bucket" "foo-bucket" {
  #checkov:skip=CKV_AWS_20:The bucket is a public static content host
  region        = var.region 
  bucket        = local.bucket_name
  force_destroy = true
  acl           = "public-read"
}