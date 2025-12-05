variable "s3_bucket_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "region" {
  type        = string
  description = "AWS region"
}
