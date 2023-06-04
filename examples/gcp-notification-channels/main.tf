data "terraform_remote_state" "projects" {
  backend = "gcs"

  config = {
    bucket = "bucket"
    prefix = "test-framework/projects"
  }
}

module "notification_channels" {
    source = "../../modules/gcp-notification-channels"
    notification_channels =     {
        email: [
            {contact: "muhammet.fatih.bostanci@devoteam.com", display_name: "m2"},
            {contact: "example@_devoteam.com", display_name: "test acc"},
            ]
        sms: [
            {contact: "+49111", display_name: "emergency"},
        ]
    }
    project_id = data.terraform_remote_state.projects.outputs.project_numbers["test-budget-alerts"]
}

output "list_of_ids" {
    value = module.notification_channels.list_of_notification_channel_ids
}