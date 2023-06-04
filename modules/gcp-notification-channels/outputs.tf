locals {
    list_of_notification_channel_ids = merge(
        google_monitoring_notification_channel.sms_notification_channels, 
        google_monitoring_notification_channel.email_notification_channels,
        )

}

output "list_of_notification_channel_ids" {
    value = local.list_of_notification_channel_ids
    description = <<EOT
      The full REST resource name for the channels. 
      The syntax is: display_name => projects/[PROJECT_ID]/notificationChannels/[CHANNEL_ID] 
      The [CHANNEL_ID] is automatically assigned by the server on creation.
    EOT
}