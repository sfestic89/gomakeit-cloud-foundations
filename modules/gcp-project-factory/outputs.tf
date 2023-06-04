output "project_number" {
  value = merge(module.project)#.project_numbers  
}

output "project_ids" {
  value = module.project#.project_ids
}

# output "notification_channel_ids" {
#   value = module.notification_channels.list_of_notification_channel_ids
# }