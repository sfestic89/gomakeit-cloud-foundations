resource "google_cloud_identity_group" "default" {
  parent       = var.parent
  display_name = var.display_name
  description  = var.description
  labels       = var.labels

  group_key {
    id        = var.group_key.id
    namespace = try(var.group_key.namespace, null)
  }

  initial_group_config = var.initial_group_config
}

