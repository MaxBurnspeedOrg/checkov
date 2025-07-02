module "VPC" {
    vpc_name = var.vpc_name
}

# --- Demo S3 Bucket (intentional error: public ACL) ---
# checkov:skip=CKV2_AWS_62: i dont need event notifications
resource "aws_s3_bucket" "demo_bucket" {
  bucket = "demo-insecure-bucket-${random_id.bucket_id.hex}"
  acl    = "public-read" # Checkov will flag this as insecure

  tags = {
    Name = "DemoInsecureBucket"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}

# --- Demo EC2 Instance (intentional error: no security group) ---
resource "aws_instance" "demo_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Example AMI, update as needed
  instance_type = "t2.micro"
  # No security group specified (Checkov will flag this)

  tags = {
    Name = "DemoEC2"
  }
}

# --- Demo Security Group (intentional error: open to the world) ---
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "Allow all inbound traffic (insecure)"
  vpc_id      = module.VPC.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Checkov will flag this
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- Demo IAM User (intentional error: inline policy with wildcard) ---
resource "aws_iam_user" "demo_user" {
  name = "demo_user"
}

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