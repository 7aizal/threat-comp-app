variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "validation_records" {
  description = "List of ACM DNS validation records to create in Cloudflare"
  type = list(object({
    domain_name           = string
    resource_record_name  = string
    resource_record_type  = string
    resource_record_value = string
  }))
}


variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API Token with DNS edit permissions"
  
}