variable "project_id" {
  type        = string
  description = "ID "
}

variable "org_id" {
  type        = number
  description = "Organizatin under which the setup project will be created"
}

variable "billing_account" {
  type        = string
  description = "Billing Account that will be linked to the setup project"
}

variable "enabled_apis" {
  type        = set(string)
  description = "The APIs enabled on the setup project"
}

variable "state_bucket_location" {
  type        = string
  description = "Location of the state bucket"
}

variable "service_account_id" {
  type        = string
  description = "ID of the Service Account to run Terraform"
}

variable "service_account_display_name" {
  type        = string
  description = "Display name of the Service Account to run Terraform"
}

variable "sa_user_group" {
  type        = string
  description = "The users that will be allowed to impersonate the service account for running terraform."
}