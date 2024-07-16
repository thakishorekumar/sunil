# Health checks
resource "aws_route53_health_check" "primary_health_check" {
  provider      = aws.primary
  type          = "HTTP"
  resource_path = "/"
  fqdn          = aws_lb.web-alb.dns_name
}

resource "aws_route53_health_check" "secondary_health_check" {
  provider      = aws.secondary
  type          = "HTTP"
  resource_path = "/"
  fqdn          = "route53.srilakshminagar.com"
}

# Route 53 zone
data "aws_route53_zone" "primary_zone" {
  provider = aws.primary
  name     = "srilakshminagar.com" # Replace with your domain name
}

# Primary Route 53 record
resource "aws_route53_record" "www_primary" {
  provider = aws.primary
  zone_id  = data.aws_route53_zone.primary_zone.zone_id
  name     = "route53.srilakshminagar.com"
  type     = "A"

  alias {
    name                   = aws_lb.web-alb.dns_name
    zone_id                = aws_lb.web-alb.zone_id
    evaluate_target_health = true
  }

  failover_routing_policy {
    type = "PRIMARY"
  }

  set_identifier  = "primary"
  health_check_id = aws_route53_health_check.primary_health_check.id

  lifecycle {
    create_before_destroy = true
  }
}

# Secondary Route 53 record
resource "aws_route53_record" "www_secondary" {
  provider = aws.secondary
  zone_id  = data.aws_route53_zone.primary_zone.zone_id
  name     = "route53.srilakshminagar.com"
  type     = "A"
  ttl      = 60
  records  = [aws_instance.DR_instance.public_ip]

  failover_routing_policy {
    type = "SECONDARY"
  }

  set_identifier  = "secondary"
  health_check_id = aws_route53_health_check.secondary_health_check.id

  lifecycle {
    create_before_destroy = false
  }
}
