provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "checkov-test-insecure-bucket"

  acl = "public-read"  # This will trigger a Checkov finding

  tags = {
    Name        = "Insecure bucket"
    Environment = "Dev"
  }
}
