output "state_bucket_name" {
  value = aws_s3_bucket.state_bucket.bucket
}

output "log_bucket_name" {
  value = aws_s3_bucket.log_bucket.bucket
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tf_locks.name
}

output "ecr_repository_url" {
  value = var.create_ecr ? aws_ecr_repository.repo[0].repository_url : null
}

output "region" {
  value = var.region
}
