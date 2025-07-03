provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "checkov-test-insecure-bucket"

  # checkov:skip=CKV_AWS_52: Public read access is acceptable for this test bucket
  acl = "public-read"  #  This would normally trigger CKV_AWS_52

  tags = {
    Name        = "Insecure bucket"
    Environment = "Dev"
  }
}
