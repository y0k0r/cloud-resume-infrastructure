resource "aws_acm_certificate" "cert_tr_com" {
  domain_name               = local.site_domain 
  validation_method         = "DNS"
  subject_alternative_names = var.create_redirect ? ["www.${var.domain_name}"] : [] 

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
  zone_id = data.aws_route53_zone.site.zone_id 
  records = [each.value.record]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation_tr_com" {
  certificate_arn         = aws_acm_certificate.cert_tr_com.arn
  validation_record_fqdns = [for record in aws_route53_record.r53_validation_records_tr_com : record.fqdn]
}