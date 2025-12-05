resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = var.subject_alternative_names

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn

  
  validation_record_fqdns = [
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.resource_record_name
  ]
}
 # this is because im using cloudflare for my dns management, this allows acm to only need the fqdns from cloudflare, cloudflare in the dns module will handle the rest.