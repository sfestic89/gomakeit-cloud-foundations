provider "google" {
  alias                 = "impersonation"
  billing_project       = "terraform-project-385615"
  user_project_override = true
}

resource "google_access_context_manager_service_perimeter" "bridge_service_perimeter" {
  for_each = var.bridge_perimeters

  provider       = google.impersonation
  perimeter_type = "PERIMETER_TYPE_BRIDGE"
  parent         = each.value.parent
  name           = format("${each.value.parent}/servicePerimeters/%s", each.key)
  title          = each.value.title
  dynamic "status" {
    for_each = [each.value.status]

    content {
      resources = [for project_number in status.value.resources :
      "projects/${project_number}"]
    }
  }
}
