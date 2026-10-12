variable "create_redirect" {
  type    = bool
  default = false
}

variable "sub_domain" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}