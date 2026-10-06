module "domain"  {
    source = "../../modules/domain"
    
    domain_name = var.domain_name
}