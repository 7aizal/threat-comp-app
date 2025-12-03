resource "cloudflare_dns_record" "acm_validation" {
  for_each = {
    for r in var.validation_records :
    r.domain_name => r
  }

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  content = each.value.resource_record_value
  ttl     = 300
  proxied = false
}
