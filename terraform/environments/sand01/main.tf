# --- Demo S3 Bucket (intentional error: public ACL) ---

# checkov:skip=CKV_AWS_21: Public ACL is intentional
# checkov:skip=CKV2_AWS_62: Public ACL is intentional
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "demo-insecure-bucket-${random_id.bucket_id.hex}"
  acl    = "public-read" # Checkov will flag this as insecure

  tags = {
    Name = "DemoInsecureBucket"
  }
}

# --- Demo EC2 Instance (intentional errors for demo purposes) ---

# checkov:skip=CKV2_AWS_126: "Detailed monitoring is intentionally disabled for demo"
# checkov:skip=CKV2_AWS_135: "EBS optimization is intentionally omitted"
# checkov:skip=CKV2_AWS_79: "IMDSv1 is used intentionally in this test config"
# checkov:skip=CKV2_AWS_8: "EBS encryption not enabled intentionally"
resource "aws_instance" "demo_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI, update as needed
  instance_type = "t2.micro"
  # No security group specified (Checkov will flag this)

  tags = {
    Name = "DemoEC2"
  }
}

/*
# --- Demo Security Group (intentional error: open to the world) ---

# checkov:skip=CKV_AWS_24: Open ingress is intentional for demo
# checkov:skip=CKV_AWS_277: Allowing all traffic on all ports is intentional for demo
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "Allow all inbound traffic (insecure)"
  vpc_id      = module.VPC.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
*/

# --- Demo IAM User (intentional error: inline policy with wildcard) ---

resource "aws_iam_user" "demo_user" {
  name = "demo_user"
}

# checkov:skip=CKV_AWS_40: Wildcard IAM policy is intentional for demo purposes
resource "aws_iam_user_policy" "demo_policy" {
  name = "demo_policy"
  user = aws_iam_user.demo_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "*"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
