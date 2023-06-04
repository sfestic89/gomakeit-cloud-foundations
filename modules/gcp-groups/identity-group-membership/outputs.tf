output "group_membership_id" {
  description = "The ID of the created group membership."
  value       = google_cloud_identity_group_membership.default.id
}
