provider "aws" {
  region = "us-east-1"
}

#-----------------------
# S3 Bucket
#-----------------------

resource "aws_s3_bucket" "foo_bucket" {
  #checkov:skip=CKV_AWS_20:The bucket is for public static content
  #checkov:skip=CKV_AWS_21:This is a test environment; encryption is not required
  bucket        = "checkov-test-bucket"
  acl           = "public-read"
  force_destroy = true
}

#-----------------------
# EC2 Instance
#-----------------------

resource "aws_instance" "web_server" {
  #checkov:skip=CKV_AWS_79:Instance needs a public IP for testing
  #checkov:skip=CKV_AWS_135:No IAM profile is intentionally attached
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  associate_public_ip_address = true

  tags = {
    Name = "CheckovTestInstance"
  }
}

#-----------------------
# Security Group
#-----------------------

resource "aws_security_group" "open_sg" {
  #checkov:skip=CKV_AWS_24:Port 22 is needed for remote dev access
  #checkov:skip=CKV_AWS_23:Full outbound access is acceptable in this test
  name        = "checkov-open-sg"
  description = "Allow SSH from anywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#-----------------------
# IAM Policy
#-----------------------

resource "aws_iam_policy" "over_permissive" {
  #checkov:skip=CKV_AWS_40:Wildcard actions are allowed in this test policy
  #checkov:skip=CKV_AWS_41:Wildcard resources are needed for dev tools 
  name = "dev-over-permissive"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

#-----------------------
# RDS Instance
#-----------------------

resource "aws_db_instance" "rds_test" {
  #checkov:skip=CKV_AWS_17:Storage encryption is skipped for performance testing
  #checkov:skip=CKV_AWS_118:Public RDS is allowed temporarily
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = "checkovtest"
  username             = "admin"
  password             = "Password123!"
  publicly_accessible  = true
  skip_final_snapshot  = true
}
