# resource "google_logging_project_bucket_config" "prj_lvl_log_bucket" {
#     project    = var.logging_project_id
#     location  = var.prj_log_sink_config.log_bucket_configs.location
#     retention_days = var.prj_log_sink_config.log_bucket_configs.retention_days
#     bucket_id = var.prj_log_sink_config.log_bucket_configs.bucket_id
# }

resource "google_logging_project_sink" "my-sink" {
  for_each = try({ for sink in var.prj_log_sink_config : sink.name => sink }, {})
  name     = each.key

  destination = each.value.destination

  filter      = each.value.filter
  description = each.value.description
  project     = each.value.project_id
  disabled    = each.value.disabled

  unique_writer_identity = each.value.unique_writer_identity

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