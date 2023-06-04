resource "google_billing_budget" "budget" {
  for_each        = {for obj in var.budget_configs: obj.display_name => obj}
  billing_account = each.value.billing_account_id
  display_name    = each.value.display_name

  budget_filter {
    projects = toset([for number in each.value.project_numbers: "projects/${number}"])
    services = each.value.services
  }



  amount {
    specified_amount {
      currency_code = each.value.currency_code
      units         = each.value.amount
    }
  }

  dynamic "threshold_rules" {
    for_each = each.value.threshold_percentages
    content {
      threshold_percent = threshold_rules.value
    }
  }

  all_updates_rule {
    monitoring_notification_channels = each.value.notification_channel_ids
    disable_default_iam_recipients   = each.value.disable_default_iam_recipients
  }
}
