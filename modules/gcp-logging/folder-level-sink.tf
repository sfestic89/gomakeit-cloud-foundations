# resource "google_logging_folder_bucket_config" "basic" {
#     folder    = var.folder_log_sink_config.folder_id
#     location  = var.folder_log_sink_config.log_bucket_configs.location
#     retention_days = var.folder_log_sink_config.log_bucket_configs.retention_days
#     bucket_id = var.folder_log_sink_config.log_bucket_configs.bucket_id
# }

resource "google_logging_folder_sink" "my-sink" {
  for_each = try({ for sink in var.folder_log_sink_config : sink.name => sink }, {})

  name = each.key

  destination = each.value.destination

  filter           = each.value.filter
  description      = each.value.description
  folder           = each.value.folder_id
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