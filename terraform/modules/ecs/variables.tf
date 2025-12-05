variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for ECS networking"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs"
}

variable "execution_role_arn" {
  type        = string
  description = "IAM role used by ECS task execution"
}

variable "task_role_arn" {
  type        = string
  description = "IAM role used by ECS tasks"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group ID for ECS service"
}

variable "alb_target_group_arn" {
  type        = string
  description = "ALB target group ARN"
}

variable "container_name" {
  type        = string
  description = "ECS container name"
}

variable "container_image" {
  type        = string
  description = "ECR image URI"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS tasks"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to ECS resources"
}
variable "ecs_security_group_id" {
  type = string
}
variable "tg_arn" {
  type = string
}

variable "region" {
  type        = string
  description = "AWS region"
}
