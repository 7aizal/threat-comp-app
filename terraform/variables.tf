

variable "region" {
  description = "AWS region to deploy resources into"
  type = string
}


variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_azs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_azs" {
  type = list(string)
}


variable "alb_name" {
  type = string
}

variable "internal" {
  type = bool
}

variable "load_balancer_type" {
  type = string
}


variable "tg_name" {
  type = string
}

variable "tg_port" {
  type = number
}

variable "tg_protocol" {
  type = string
}

variable "target_type" {
  type = string
}


variable "health_check_path" {
  type = string
}

variable "health_check_protocol" {
  type = string
}

variable "matcher" {
  type = string
}

variable "health_check_interval" {
  type = number
}

variable "health_check_timeout" {
  type = number
}

variable "healthy_threshold" {
  type = number
}

variable "unhealthy_threshold" {
  type = number
}


variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}

variable "default_action_type" {
  type = string
}



variable "cluster_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "container_port" {
  type = number
}

variable "desired_count" {
  type = number
}



variable "cloudflare_zone_id" {
  type = string
}

variable "record_name" {
  type = string
}

variable "record_type" {
  type = string
}

variable "evaluate_target_health" {
  type = bool
}


variable "s3_bucket_name" {
  type = string
}


variable "domain_name" {
  type = string
}

variable "san_domains" {
  type    = list(string)
  default = []
}

variable "cloudflare_api_token" {
  description = "token for cloudflare"
  sensitive = true
  type = string
  default = null

}
variable "tags" {
  type = map(string)
  default = {
    Project = "Default"
    Env     = "dev"
  }
}

variable "acm_certificate_arn" {
  type = string
}


variable "common_tags" {
  description = "Common tags for all resources"
  type = map(string)
}

variable "ecs_cpu" {
  type = number
}

variable "ecs_memory" {
  type = number
}


variable "app_bucket_name" {
  description = "S3 bucket used by the ECS application"
  type        = string
}
