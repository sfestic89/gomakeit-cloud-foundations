resource "google_storage_bucket" "log-bucket" {
  name     = ""
  location = "EU"
  project = ""
}



module "sinks" {
  source = "../../modules/gcp-logging"
  logging_project_id = ""
  org_log_sink_config = [{
    name = "org_logs"
    org_id = ""
    filter =<<EOT
    protoPayload.methodName="SetIamPolicy"
    EOT 

    destination = "storage.googleapis.com/${google_storage_bucket.log-bucket.name}"
  },]
  prj_log_sink_config = [{
    name = "prj_logs"
    project_id = ""
    filter =<<EOT
    protoPayload.methodName="SetIamPolicy"
    EOT 

    destination = "storage.googleapis.com/${google_storage_bucket.log-bucket.name}"
  },]
  folder_log_sink_config = [{
    name = "fldr_logs"
    folder_id = ""
    filter =<<EOT
    protoPayload.methodName="SetIamPolicy"
    EOT 

    destination = "storage.googleapis.com/${google_storage_bucket.log-bucket.name}"
  },]
  billing_account_log_sink_config = [{
    name = "billing_logs"
    billing_account_id = ""
    filter = ""
    destination = "storage.googleapis.com/${google_storage_bucket.log-bucket.name}"
  }]
}

resource "google_project_iam_member" "log-writer" {
  project = ""
  role    = "roles/storage.objectCreator"
  member  = module.sinks.org_log_sink_writer_identities["org_logs"]
}