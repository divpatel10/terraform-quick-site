resource "aws_route53_zone" "zone" {
  name = var.domain_name
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.react_app_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.react_app_distribution.hosted_zone_id
    evaluate_target_health = true
  }
}
