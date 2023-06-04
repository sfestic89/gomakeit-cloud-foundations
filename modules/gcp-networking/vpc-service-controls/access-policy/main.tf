provider "google" {
  alias                 = "impersonation"
  billing_project       = "terraform-project-385615"
  user_project_override = true

}

resource "google_access_context_manager_access_policy" "access_policies" {
  for_each = { for idx, policy in var.access_policies : idx => policy }

  provider = google.impersonation
  parent   = each.value.parent
  title    = each.value.title
  scopes   = each.value.scopes
}
