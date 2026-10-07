resource "aws_s3_bucket" "tr_com" {
  bucket = local.site_domain
}

resource "aws_s3_bucket" "www_tr_com" {
  count = var.create_redirect ? 1 : 0
  bucket = "www.${var.domain_name}"
  
}

resource "aws_s3_bucket_website_configuration" "tr_com" {
  bucket = aws_s3_bucket.tr_com.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_website_configuration" "www_tr_com" {
  count = var.create_redirect ? 1 : 0
  bucket = aws_s3_bucket.www_tr_com[0].id

  redirect_all_requests_to {
    host_name = var.domain_name
    protocol  = "https"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.tr_com.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "read_only_tr_com" {
  bucket = aws_s3_bucket.tr_com.id
  policy = data.aws_iam_policy_document.read_only_tr_com.json
}

data "aws_iam_policy_document" "read_only_tr_com" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.tr_com.arn}/*"
    ]
  }
}