resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = var.validation_method
}

resource "aws_route53_record" "cert_validation" {
  zone_id = var.route53_zone_id

  name    = var.domain_validation_options[0].resource_record_name
  type    = var.domain_validation_options[0].resource_record_type
  records =  var.domain_validation_options[0].resource_record_value

  ttl = var.record_ttl
}

resource "aws_acm_certificate_validation" "cert_validation_complete" {
  certificate_arn         = var.certificate_arn
  validation_record_fqdns = var.validation_record_fqdns
}
