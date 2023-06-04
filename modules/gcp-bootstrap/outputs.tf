output "projects_terraform_service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.iam_service_account.email
}

output "state_bucket" {
  description = "Bucket used for storing terraform state."
  value       = google_storage_bucket.state_bucket.name
}