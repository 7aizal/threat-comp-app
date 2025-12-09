resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "tg" {
  name        = var.tg_name
  port        = var.tg_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    matcher             = var.matcher
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

resource "aws_lb_listener" "http_redirect_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
