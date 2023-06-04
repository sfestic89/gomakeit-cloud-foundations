resource "google_folder" "folder" {
  for_each = var.folders

  display_name = each.value.display_name
  parent       = each.value.parent

}
