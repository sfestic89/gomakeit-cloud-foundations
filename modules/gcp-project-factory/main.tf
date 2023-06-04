locals {
  check_if_exactly_one_of_folder_or_org_id_is_set = anytrue([for prj in var.project_configs:
   (prj.org_id == "" && prj.folder_id == "") || (prj.org_id != "" && prj.folder_id != "")
  ])
  validate = local.check_if_exactly_one_of_folder_or_org_id_is_set ? tobool("Either set the org id or folder id, exactly on of those has to be set on all projects"): true
}


# 1. Create project
module "project" {
  source = "git@github.com:devoteamgcloud/gcp-dynamic-lz-framework.git//modules/gcp-projects?ref=features-by-fatih"
  for_each = {for project in var.project_configs: project.project_name => project}

  folder_id = each.value.folder_id
  org_id = each.value.org_id

  projects = {
    "${each.key}" = {
      name            = each.key
      project_id      = each.value.project_id
      billing_account = each.value.billing_account_id
      labels = each.value.labels
    },
  }
}

locals {
  # [{prj-name, [...apis]}, ...] -> [[{prj-1-name, api1}, ..., {prj-1, api-n}],...,[{prj-m-name, api-n}]] ->[{prj-1-name, api1},...,{prj-m-name, api-n}]
  prj_api_list = flatten([for prj in var.project_configs: 
    [for api in prj.apis: {
      "prj-name": prj.project_name
      "api": api
      }]
    ])

}

# 2. Enable APIs
resource "google_project_service" "apis" {
  for_each                   = {for obj in local.prj_api_list: "${obj.prj-name}_${obj.api}" => obj}
  project                    = module.project[each.value.prj-name].project_ids[each.value.prj-name]
  service                    = each.value.api
  disable_on_destroy         = true
  disable_dependent_services = true
}

# 3. Create notification channels for budget alerts
module "notification_channels" {
    source = "git@github.com:devoteamgcloud/gcp-dynamic-lz-framework.git//modules/gcp-notification-channels?ref=features-by-fatih"
    for_each = {for project in var.project_configs: project.project_name => project}
    notification_channels = each.value.notification_channels
    project_id = each.value.is_monitoring_prj ? module.project[each.key].project_ids[each.key] : module.project[var.monitoring-prj-name].project_ids[var.monitoring-prj-name]
}

# 4. Create budget alerts
module "standard_budget_alerts" {
  source = "git@github.com:devoteamgcloud/gcp-dynamic-lz-framework.git//modules/gcp-budget-alerts?ref=features-by-fatih"
  depends_on = [ module.notification_channels ]
  for_each = {for project in var.project_configs: project.project_name => project}
  budget_configs = [
    {
      billing_account_id       = each.value.billing_account_id
      display_name             = each.value.budget_config.name
      currency_code            = each.value.budget_config.currency_code
      threshold_percentages    = each.value.budget_config.thresholds
      amount                   = each.value.budget_config.amount
      disable_default_iam_recipients = each.value.budget_config.disable_default_iam_recipients
      project_numbers          = [module.project[each.key].project_numbers[each.key]]
      notification_channel_ids = [for k, v in module.notification_channels[each.key].list_of_notification_channel_ids: v.name]
  }, ]
}

