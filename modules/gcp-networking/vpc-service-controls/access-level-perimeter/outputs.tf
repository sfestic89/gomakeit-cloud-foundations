output "names" {
  description = "Access Level names"
  value = {
    for key, access_level in google_access_context_manager_access_level.access-level :
    key => access_level.name
  }
}
