resource "aws_acm_certificate" "cert_tc_com" {
  domain_name               = "www.toyokocuthbert.com"
  validation_method         = "DNS"
  subject_alternative_names = ["toyokocuthbert.com"]

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate Validation via DNS
resource "aws_route53_record" "r53_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.cert_tc_com.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = aws_route53_zone.tc_com.id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation_tc_com" {
  certificate_arn         = aws_acm_certificate.cert_tc_com.arn
  validation_record_fqdns = [for record in aws_route53_record.r53_validation_records : record.fqdn]
}

resource "aws_acm_certificate" "cert_tr_com" {
  domain_name               = "www.toyokorivera.com"
  validation_method         = "DNS"
  subject_alternative_names = ["toyokorivera.com"]

  lifecycle {
    create_before_destroy = true
  }
}

# Certificate Validation via DNS
resource "aws_route53_record" "r53_validation_records_tr_com" {
  for_each = {
    for dvo in aws_acm_certificate.cert_tr_com.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = aws_route53_zone.tr_com.id
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation_tr_com" {
  certificate_arn         = aws_acm_certificate.cert_tr_com.arn
  validation_record_fqdns = [for record in aws_route53_record.r53_validation_records_tr_com : record.fqdn]
}