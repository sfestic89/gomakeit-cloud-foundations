# resource "google_logging_organization_bucket_config" "basic" {
#     organization    = var.org_log_sink_config.org_id
#     location  = var.org_log_sink_config.log_bucket_configs.location
#     retention_days = var.org_log_sink_config.log_bucket_configs.retention_days
#     bucket_id = var.org_log_sink_config.log_bucket_configs.bucket_id
# }

resource "google_logging_organization_sink" "my-sink" {
  for_each = try({ for sink in var.org_log_sink_config : sink.name => sink }, {})

  name = each.key

  destination = each.value.destination

  filter           = each.value.filter
  description      = each.value.description
  org_id           = each.value.org_id
  disabled         = each.value.disabled
  include_children = each.value.include_children

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