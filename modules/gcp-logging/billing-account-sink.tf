# resource "google_logging_billing_account_bucket_config" "basic" {
#     billing_account    = var.billing_account_log_sink_config.billing_account_id
#     location  = var.billing_account_log_sink_config.log_bucket_configs.location
#     retention_days = var.billing_account_log_sink_config.log_bucket_configs.retention_days
#     bucket_id = var.billing_account_log_sink_config.log_bucket_configs.bucket_id
# }

resource "google_logging_billing_account_sink" "my-sink" {
  for_each = try({ for sink in var.billing_account_log_sink_config : sink.name => sink }, {})

  name = each.key

  destination = each.value.destination

  filter          = each.value.filter
  description     = each.value.description
  billing_account = each.value.billing_account_id
  disabled        = each.value.disabled

  dynamic "bigquery_options" {
    for_each = each.value.bigquery_options == null ? [] : [each.value.bigquery_options]
    content {
      use_partitioned_tables = bigquery_options.value.use_partitioned_tables
    }
  }

  dynamic "exclusions" {
    for_each = each.value.exclusions
    content {
      name        = exclusions.value.name
      description = exclusions.value.description
      filter      = exclusions.value.filter
      disabled    = exclusions.value.disabled
    }
  }
}

