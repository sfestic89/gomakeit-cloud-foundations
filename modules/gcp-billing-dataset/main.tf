# Used for https://cloud.google.com/billing/docs/how-to/visualize-data
resource "google_bigquery_dataset" "billing_dataset" {
  dataset_id    = var.dataset_id
  project       = var.project_id
  friendly_name = var.friendly_name
  location      = var.billing_export_dataset_location 
}