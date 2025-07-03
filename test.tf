resource "aws_s3_bucket" "demo_bucket" {
  bucket = "demo-insecure-bucket"
  acl    = "public-read" # Checkov will flag this as insecure

  tags = {
    Name = "DemoInsecureBucket"
  }
}

resource "aws_instance" "test_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  # No IAM role attached (Checkov will