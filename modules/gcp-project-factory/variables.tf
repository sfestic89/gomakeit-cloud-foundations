variable "project_configs" {
  type = list(object({
    folder_id = optional(string, "")
    org_id = optional(string, "")
    billing_account_id = string
    project_id = string
    project_name = string
    labels = map(string)
    apis = list(string)
    notification_channels = map(list(object({
      contact      = string
      display_name = string
    })))
    is_monitoring_prj = optional(bool, false)
    
    budget_config = object({
      name = string
      currency_code = string
      thresholds = list(number)
      amount = number
      disable_default_iam_recipients = optional(bool, true)
    })
  }))
}

variable "monitoring-prj-name" {
  type = string
}

/*
variable "folder_id" {
  type = string
}

variable "billing_account_id" {
type = string
}

variable "auto_create_network" {
  type = bool
  default = false
}

variable "project_id" {
  type = string
}

variable "project_name" {
  type = string
}

variable "labels" {
  type = map(string)
}

variable "apis" {
  type = list(string)
}

#### Notification Channel vars
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
            {contact: "example@devoteam.com", display_name: "m2"},
            {contact: "test@dev.devoteam.de", display_name: "test acc"},
            ]
        sms: [
            {contact: "123", display_name: "emergency"},
        ]
    }
  EOT
}

variable "is_monitoring_prj" {
  type = bool
  default = false
  description = "If the project to be created is the monitoring project. If true, the notification channels will be created "
}

variable "monitoring_project_id" {
  type = string
  default = ""
  description = "Project id where the notification channels should be created"
}

#### Budget Alert vars

variable "budget_display_name" {
  type = string
}

variable "budget_currency_code" {
  type = string
}

variable "budget_thresholds" {
  type = list(number)
}

variable "budget_amount" {
  type = number
}


variable "disable_default_iam_recipients" {
  type = bool
  default = true
}
*/
