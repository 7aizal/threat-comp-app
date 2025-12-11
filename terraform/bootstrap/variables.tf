variable "region" {
  description = "AWS region for backend resources"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "state_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
}

variable "log_bucket_name" {
  description = "S3 bucket name for S3 access logs"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
}

variable "create_ecr" {
  description = "Whether to create an ECR repository"
  type        = bool
  default     = false
}

variable "ecr_repo_name" {
  description = "Name of the ECR repository to create (if enabled)"
  type        = string
  default     = "default-repo"
}


