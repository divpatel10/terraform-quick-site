resource "aws_route53_zone" "my_domain_hosted_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "main_bucket_record" {
  zone_id = aws_route53_zone.my_domain_hosted_zone.id
  name = var.domain_name
  type = "A"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
  
}

resource "aws_route53_record" "second_record" {
  zone_id = aws_route53_zone.my_domain_hosted_zone.id
  name = "www.${var.domain_name}"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
