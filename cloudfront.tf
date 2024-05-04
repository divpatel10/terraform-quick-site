resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id = aws_s3_bucket.site.bucket_regional_domain_name
  }

  aliases = ["www.${var.domain_name}", var.domain_name]

  enabled             = true
  is_ipv6_enabled     = true
  # default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.site.bucket_regional_domain_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

     viewer_certificate {
        acm_certificate_arn      = aws_acm_certificate_validation.cert.certificate_arn
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2021"
    }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
