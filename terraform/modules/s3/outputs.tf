output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.bucket.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.bucket.arn
}

output "versioning_status" {
  description = "Versioning status"
  value       = aws_s3_bucket_versioning.versioning.versioning_configuration[0].status
}

output "object_lock_enabled" {
  description = "Object lock enabled"
  value       = aws_s3_bucket_object_lock_configuration.object_lock.object_lock_enabled
}

output "public_access_block_id" {
  description = "Public access block ID"
  value       = aws_s3_bucket_public_access_block.block.id
}
