terraform {
  required_version = "~>1.2.1"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~>4.21.0"
    }
  }
  backend "gcs" {
    bucket = "bkt-b-seed-tf-state-276138" # GCS bucket for Terraform Remote State
    prefix = "vpc"
  }
  experiments = [module_variable_optional_attrs]
}
