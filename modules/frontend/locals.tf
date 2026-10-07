locals {
    site_domain = var.sub_domain != null ? "${var.sub_domain}.${var.domain_name}" : var.domain_name
}