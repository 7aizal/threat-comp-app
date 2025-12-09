terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}


# LOG BUCKET (Already Exists)


resource "aws_s3_bucket" "log_bucket" {
  bucket = var.log_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.log_bucket_name
    Environment = var.environment
  }
}


# STATE BUCKET 

resource "aws_s3_bucket" "state_bucket" {
  bucket = var.state_bucket_name

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name        = var.state_bucket_name
    Environment = var.environment
  }
}

# Versioning for backend bucket
resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encryption for backend bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "state_encryption" {
  bucket = aws_s3_bucket.state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DO NOT TOUCH — required for backend security
resource "aws_s3_bucket_public_access_block" "state_public_access" {
  bucket = aws_s3_bucket.state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# DYNAMODB TABLE 

resource "aws_dynamodb_table" "tf_locks" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = var.lock_table_name
    Environment = var.environment
  }
}
