output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}

output "http_listener_arn" {
  value = aws_lb_listener.http_redirect_listener.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.https_listener.arn
}
