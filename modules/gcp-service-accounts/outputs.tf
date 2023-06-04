output "sa_name" {
  value = tomap({
    for k, name in google_service_account.vsf_service_accounts : k => name.id
  })
}

output "sa_emails" {
  value = tomap({
    for k, v in google_service_account.vsf_service_accounts : k => v.email
  })
}
