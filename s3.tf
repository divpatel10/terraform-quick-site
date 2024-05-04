resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "my_website" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "portfolio" {
  for_each = fileset("${var.website_html}", "*")
  bucket   = aws_s3_bucket.site.id
  key      = each.value
  source   = "${var.website_html}/${each.value}"
  etag     = filemd5(".${var.website_html}/${each.value}")
}


resource "aws_s3_bucket_policy" "site_policy" {
  bucket = aws_s3_bucket.site.id
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
    {
    "Sid"       : "PublicReadGetObject",
    "Effect"    : "Allow",
    "Principal" : "*",
    "Action"    : ["s3:GetObject"],
    "Resource" : "${aws_s3_bucket.site.arn}/*"
    }
  ]
  }
  POLICY
}



