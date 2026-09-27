resource "aws_s3_bucket" "tc_com" {
  bucket = "toyokocuthbert.com"
}

resource "aws_s3_bucket" "www_tc_com" {
  bucket = "www.toyokocuthbert.com"
}

resource "aws_s3_bucket_website_configuration" "tc_com" {
  bucket = aws_s3_bucket.tc_com.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_website_configuration" "www_tc_com" {
  bucket = aws_s3_bucket.www_tc_com.id

  redirect_all_requests_to {
    host_name = "toyokocuthbert.com"
    protocol  = "https"
  }
}

resource "aws_s3_bucket_public_access_block" "public-access" {
  bucket = aws_s3_bucket.tc_com.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "read_only" {
  bucket = aws_s3_bucket.tc_com.id
  policy = data.aws_iam_policy_document.read_only.json
}

data "aws_iam_policy_document" "read_only" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.tc_com.arn}/*"
    ]
  }
}

# ToyokoRivera.com
resource "aws_s3_bucket" "tr_com" {
  bucket = "toyokorivera.com"
}

resource "aws_s3_bucket" "www_tr_com" {
  bucket = "www.toyokorivera.com"
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
  bucket = aws_s3_bucket.www_tr_com.id

  redirect_all_requests_to {
    host_name = "toyokorivera.com"
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