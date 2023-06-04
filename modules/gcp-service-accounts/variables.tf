variable "service_accounts" {
  description = "GCP Service Accounts"
  type = map(object({
    project      = string
    account_id   = string
    display_name = string
    description  = string
  }))
}
