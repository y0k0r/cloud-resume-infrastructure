module "frontend" {
  source          = "../../modules/frontend"
  create_redirect = var.create_redirect
  sub_domain      = var.sub_domain
  domain_name     = var.domain_name
}