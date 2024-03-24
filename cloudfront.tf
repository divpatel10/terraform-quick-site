resource "aws_cloudfront_distribution" "react_app_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.my_website.website_domain
    origin_id   = "S3-${var.bucket_name}"
  }

  aliases = ["www.${var.domain_name}", var.domain_name]

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.bucket_name}"

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

  price_class = "PriceClass_All"

     viewer_certificate {
        acm_certificate_arn      = aws_acm_certificate_validation.cert.certificate_arn
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.2_2019"
    }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
