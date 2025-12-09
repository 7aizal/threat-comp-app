variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "load_balancer_type" {
  description = "Type of load balancer (application | network)"
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group ID to attach to the ALB"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "tg_name" {
  description = "Target group name"
  type        = string
}

variable "tg_port" {
  description = "Port for target group"
  type        = number
}

variable "tg_protocol" {
  description = "Protocol for the target group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB and TG will reside"
  type        = string
}

variable "target_type" {
  description = "Target type (instance | ip | lambda)"
  type        = string
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
}

variable "health_check_protocol" {
  description = "Protocol for health check"
  type        = string
}

variable "matcher" {
  description = "Health check success matcher (e.g., 200-399)"
  type        = string
}

variable "health_check_interval" {
  description = "Interval between health checks (seconds)"
  type        = number
}

variable "health_check_timeout" {
  description = "Timeout for health checks (seconds)"
  type        = number
}

variable "healthy_threshold" {
  description = "Consecutive successes required"
  type        = number
}

variable "unhealthy_threshold" {
  description = "Consecutive failures required"
  type        = number
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener"
  type        = string
}

variable "tags" {
  description = "Tags to apply to ALB resources"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS region"
  type        = string
}
