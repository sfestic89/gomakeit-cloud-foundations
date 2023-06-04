resource "google_cloud_identity_group_membership" "default" {
  group = var.group

  roles {
    name = var.roles.name
  }

  preferred_member_key {
    id        = var.preferred_member_key.id
    namespace = try(var.preferred_member_key.namespace, null)
  }
}
