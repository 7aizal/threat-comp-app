output "created_validation_records" {
  description = "Cloudflare DNS records created for ACM validation"
  value       = cloudflare_dns_record.acm_validation
}

output "validation_record_names" {
  description = "List of validation record hostnames"
  value       = [for r in cloudflare_dns_record.acm_validation : r.name]
}
