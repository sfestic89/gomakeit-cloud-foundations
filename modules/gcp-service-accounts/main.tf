resource "google_service_account" "vsf_service_accounts" {
  for_each     = { for service_account, service_accounts in var.service_accounts : service_account => service_accounts }
  account_id   = each.value.account_id
  project      = each.value.project
  display_name = each.value.display_name
  description  = each.value.description
}
