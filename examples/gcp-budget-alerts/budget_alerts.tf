data "terraform_remote_state" "projects" {
  backend = "gcs"

  config = {
    bucket = "bucket"
    prefix = "test-framework/projects"
  }
}

data "terraform_remote_state" "notification_channel_ids" {
  backend = "gcs"

  config = {
    bucket = "bucket"
    prefix = "test-framework/notification_channels"
  }
}

locals {
  budget_configs = [
    {
      billing_account_id    = ""
      display_name          = "all_projects_all_services"
      currency_code         = "EUR"
      threshold_percentages = [0, 0.5]
      amount                = 1000
      project_numbers       = [for k, v in data.terraform_remote_state.projects.outputs.project_numbers : v]
      notification_channel_ids = [for k, v in data.terraform_remote_state.notification_channel_ids.outputs.list_of_ids: v.name]
    },
    {
      billing_account_id       = ""
      display_name             = "prj-test-generic-all-services"
      currency_code            = "EUR"
      threshold_percentages    = [0, 0.5, 1.0]
      amount                   = 100
      project_numbers          = [data.terraform_remote_state.projects.outputs.project_numbers["test-generic"]]
      notification_channel_ids = [data.terraform_remote_state.notification_channel_ids.outputs.list_of_ids["m2"].name]
  }]
}


module "standard_budget_alerts" {
  source         = "../../modules/gcp-budget-alerts"
  budget_configs = local.budget_configs
}