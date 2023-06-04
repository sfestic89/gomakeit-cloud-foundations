output "policy_ids" {
  description = "Access Policy IDs"
  value = {
    for key, policy in google_access_context_manager_access_policy.access_policies :
    key => policy.id
  }
}
