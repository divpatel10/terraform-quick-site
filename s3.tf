resource "aws_s3_bucket" "react_app_bucket" {
  bucket = var.bucket_name
}


data "aws_iam_policy_document" "public_read" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "${aws_s3_bucket.react_app_bucket.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "react_app_bucket_policy" {
  bucket = aws_s3_bucket.react_app_bucket.id
  policy = data.aws_iam_policy_document.public_read.json
}
resource "aws_s3_bucket_website_configuration" "my_website" {
  bucket = aws_s3_bucket.react_app_bucket.id

  index_document {
    suffix = var.website_html
  }

  error_document {
    key = var.website_html
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}