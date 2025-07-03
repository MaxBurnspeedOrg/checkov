provider "aws" {
  region = "us-east-1"
}

#checkov:skip=CKV_AWS_20:The bucket is a public static content host
resource "aws_s3_bucket" "foo-bucket" {
  region        = var.region 
  bucket        = local.bucket_name
  force_destroy = true
  acl           = "public-read"
}