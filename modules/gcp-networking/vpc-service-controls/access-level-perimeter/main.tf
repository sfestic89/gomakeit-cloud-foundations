terraform {
  required_version = ">= 0.13"
}

provider "google" {
  alias                 = "impersonation"
  billing_project       = "terraform-project-385615"
  user_project_override = true

}

resource "google_access_context_manager_access_level" "access-level" {
  for_each = var.access_levels

  provider = google.impersonation
  parent   = "accessPolicies/${each.value.policy}"
  name     = "accessPolicies/${each.value.policy}/accessLevels/${each.value.name}"
  title    = each.value.name

  basic {
    conditions {
      regions        = each.value.geographical_regions
      ip_subnetworks = each.value.ip_subnetworks

      device_policy {
        require_screen_lock    = false
        require_admin_approval = false
        require_corp_owned     = false
      }
    }
  }
}
