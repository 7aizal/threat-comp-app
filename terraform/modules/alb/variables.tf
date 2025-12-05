

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
  type        = string
  description = "Health check endpoint path"
}

variable "health_check_protocol" {
  type        = string
  description = "Protocol for health check"
}

variable "matcher" {
  type        = string
  description = "Health check success matcher (e.g., 200-399)"
}

variable "health_check_interval" {
  type        = number
  description = "Interval between health checks (seconds)"
}

variable "health_check_timeout" {
  type        = number
  description = "Timeout for health checks (seconds)"
}

variable "healthy_threshold" {
  type        = number
  description = "Consecutive successes required"
}

variable "unhealthy_threshold" {
  type        = number
  description = "Consecutive failures required"
}



variable "listener_port" {
  type        = number
  description = "Listener port (usually 80 or 443)"
}

variable "listener_protocol" {
  type        = string
  description = "Listener protocol (HTTP or HTTPS)"
}

variable "default_action_type" {
  type        = string
  description = "Default action type (forward or redirect)"
}


variable "tags" {
  description = "Tags to apply to ALB resources"
  type        = map(string)
  default     = {}
}
variable "region" {
  type        = string
  description = "AWS region"
}
