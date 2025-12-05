variable "vpc_id" {
  type        = string
  description = "VPC ID the security groups belong to"
}

variable "cidr_block" {
  type        = string
  description = "CIDR allowed into ALB"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Common tags"
}

variable "region" {
  type        = string
  description = "AWS region"
}
