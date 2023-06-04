output "folder_ids" {
  value = { for k, v in google_folder.folder : k => "folders/${v.folder_id}" }
}
