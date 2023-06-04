variable "notification_channels" {
  type = map(list(object({
    contact      = string
    display_name = string
    
  })))
  description = <<EOT

    keys:           Type of the notification channel
                    See following link for possible types: https://cloud.google.com/monitoring/alerts/using-channels-api#ncd

    contact:        Value of the notification channel, eg email address, sms number. 
                    Might need to be verified, which in return might require the enablement of the monitoring API
    display_name:   Display name of the channel
   
    eg
    {
        email: [
            {contact: "example@me.com", display_name: "m2"},
            {contact: "test@xyz.abc", display_name: "test acc"},
            ]
        sms: [
            {contact: "123", display_name: "emergency"},
        ]
    }
  EOT
}

variable "project_id" {
  type        = string
  description = "ID of the project under which the notification channels will be created. Usually this is the dedicated monitoring project."
}
