data "aws_route53_zone" "site" {
  name = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "site" {
  zone_id = data.aws_route53_zone.site.zone_id 
  name    = local.site_domain 
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "redirect" {
  count = var.create_redirect ? 1 : 0
  zone_id = data.aws_route53_zone.site.zone_id 
  name    = "www.${var.domain_name}" 
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.site.domain_name
    zone_id                = aws_cloudfront_distribution.site.hosted_zone_id
    evaluate_target_health = false
  }
}