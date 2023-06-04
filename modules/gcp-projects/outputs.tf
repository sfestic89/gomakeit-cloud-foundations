output "project_ids" {
  value = { for k, v in google_project.projects : k => v.project_id }
}

output "project_numbers" {
  value = { for k, v in google_project.projects : k => v.number }
}