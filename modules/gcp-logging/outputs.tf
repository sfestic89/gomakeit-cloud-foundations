output "org_log_sink_writer_identities" {
  value = { for k, v in google_logging_organization_sink.my-sink : k => v.writer_identity }
}