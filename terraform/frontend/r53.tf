resource "aws_route53_zone" "tc_com" {
  name = "toyokocuthbert.com"
}

resource "aws_route53domains_registered_domain" "domain_tc_com" {
  domain_name = "toyokocuthbert.com"

  name_server {
    name = aws_route53_zone.tc_com.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.tc_com.name_servers[1]
  }

  name_server {
    name = aws_route53_zone.tc_com.name_servers[2]
  }

  name_server {
    name = aws_route53_zone.tc_com.name_servers[3]
  }

  admin_privacy      = true
  registrant_privacy = true
  tech_privacy       = true
}

resource "aws_route53_record" "tc_com" {
  zone_id = aws_route53_zone.tc_com.id
  name    = "toyokocuthbert.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cf-distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_tc_com" {
  zone_id = aws_route53_zone.tc_com.id
  name    = "www.toyokocuthbert.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf-distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cf-distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


# ToyokoRivera.com
resource "aws_route53_zone" "tr_com" {
  name = "toyokorivera.com"
}

resource "aws_route53domains_registered_domain" "domain_tr_com" {
  domain_name = "toyokorivera.com"

  name_server {
    name = aws_route53_zone.tr_com.name_servers[0]
  }

  name_server {
    name = aws_route53_zone.tr_com.name_servers[1]
  }

  name_server {
    name = aws_route53_zone.tr_com.name_servers[2]
  }

  name_server {
    name = aws_route53_zone.tr_com.name_servers[3]
  }

  admin_privacy      = true
  registrant_privacy = true
  tech_privacy       = true
}

resource "aws_route53_record" "tr_com" {
  zone_id = aws_route53_zone.tr_com.id
  name    = "toyokorivera.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_tr_com" {
  zone_id = aws_route53_zone.tr_com.id
  name    = "www.toyokorivera.com"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cf_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cf_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "txt_record_protonmail_tr_com" {
  zone_id = aws_route53_zone.tr_com.id
  name = ""
  type = "TXT"
  ttl = 300
  records = [
    "protonmail-verification=3e1bbe954ed619d3b0bdee21843f8d9acd6f4d2c",
    "v=spf1 include:_spf.protonmail.ch ~all",
    "v=DMARC1; p=quarantine"
    ]
}

resource "aws_route53_record" "mx_record_protonmail_tr_com" {
  zone_id = aws_route53_zone.tr_com.id
  name = ""
  type = "MX"
  ttl = 300
  records = [
    "10 mail.protonmail.ch",
    "20 mailsec.protonmail.ch"
    ]
}

resource "aws_route53_record" "protonmail_domainkey_tr_com"{
  zone_id = aws_route53_zone.tr_com.id
  name = "protonmail._domainkey"
  type = "CNAME"
  ttl = 300
  records = ["protonmail.domainkey.dby7dqs3tyggmxqvwvk6mx33jgw4m7m6bvinv4g3h4lyytkahvomq.domains.proton.ch."]
}

resource "aws_route53_record" "protonmail2_domainkey_tr_com"{
  zone_id = aws_route53_zone.tr_com.id
  name = "protonmail2._domainkey"
  type = "CNAME"
  ttl = 300
  records = ["protonmail2.domainkey.dby7dqs3tyggmxqvwvk6mx33jgw4m7m6bvinv4g3h4lyytkahvomq.domains.proton.ch."]
}

resource "aws_route53_record" "protonmail3_domainkey_tr_com"{
  zone_id = aws_route53_zone.tr_com.id
  name = "protonmail3._domainkey"
  type = "CNAME"
  ttl = 300
  records = ["protonmail3.domainkey.dby7dqs3tyggmxqvwvk6mx33jgw4m7m6bvinv4g3h4lyytkahvomq.domains.proton.ch."]
}