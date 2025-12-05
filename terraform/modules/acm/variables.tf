variable "domain_name" {
    type = string
    description = "The domain name to request the certificate for"
  
}


variable "subject_alternative_names" {
  description = "Optional extra domain names"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags for ACM certificate"
  type        = map(string)
  default     = {}
}

variable "region" {
  type        = string
  description = "AWS region"
}

  
