terraform {
  required_version = "~> 1.2.1"

  required_providers {
    google = "~>4.21.0"
  }

  experiments = [module_variable_optional_attrs]
}
