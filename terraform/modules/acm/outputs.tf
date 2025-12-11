output "certificate_arn" {
  description = "ARN of the generated ACM certificate"
  value       = aws_acm_certificate.cert.arn
}

output "domain_validation_options" {
  description = "Validation records (CNAME) required for DNS validation"
  value = [
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    {
      domain_name           = dvo.domain_name
      resource_record_name  = dvo.resource_record_name
      resource_record_type  = dvo.resource_record_type
      resource_record_value = dvo.resource_record_value
    }
  ]
}
