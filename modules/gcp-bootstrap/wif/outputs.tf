output "workload_identity_pool_provider_resource_name" {
  description = "Workload Identity Federation pool provider resource name."
  value       = google_iam_workload_identity_pool_provider.oidc_provider.name
}

output "repository_type" {
  description = "Type of the Git platform used to host the source code and run the CI/CD pipelines"
  value       = var.repository_type
}
