locals {
  org_id    = length(var.org_id) > 0 ? var.org_id : null
  folder_id = length(var.folder_id) > 0 ? var.folder_id : null
  org_id_is_null = local.org_id == null
  folder_id_is_null = local.folder_id == null
  check_if_exactly_one_of_folder_or_org_id_is_set = (local.org_id_is_null && local.folder_id_is_null) || (!local.org_id_is_null && !local.folder_id_is_null)? tobool("Either set the org id or folder id, exactly on of those has to be set"): true
}

resource "google_project" "projects" {
  for_each = var.projects

  name            = each.value.name
  project_id      = "${each.value.name}-${random_id.project_random_suffix.hex}"
  billing_account = each.value.billing_account
  labels = var.labels
  auto_create_network = var.auto_create_network
  folder_id       = local.folder_id
  org_id          = local.org_id
}

resource "random_id" "project_random_suffix" {
  byte_length = 2
}
