# Create a Master Terraform project to contain the GCS bucket for the state, and the Service Account to run Terraform.
resource "google_project" "gcp_setup_project" {
  name            = var.project_id
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
}


# Enable the required API's on the project.
resource "google_project_service" "enabled_apis" {
  for_each = [
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "admin.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
  ]
  project = google_project.gcp_setup_project.id
  service = each.key
}


# Create a Cloud Storage bucket to host the Terraform state
resource "google_storage_bucket" "state_bucket" {
  name     = "var.bucket_name"
  project  = google_project.gcp_setup_project.project_id
  location = var.state_bucket_location
  versioning {
    enabled = true
  }
}

# Create the Service Account that will be used to run this IAM module
resource "google_service_account" "iam_service_account" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  project      = google_project.gcp_setup_project.project_id
}

# Grant the Service Account the required permissions on the GCS state bucket and the GCP Organization
resource "google_storage_bucket_iam_member" "member" {
  bucket = google_storage_bucket.state_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.iam_service_account.email}"
}

resource "google_organization_iam_member" "org_parent_iam" {
  for_each = [
    "roles/resourcemanager.organizationAdmin",
    "roles/iam.serviceAccountAdmin"
  ]

  org_id = var.org_id
  role   = each.key
  member = "serviceAccount:${google_service_account.iam_service_account.email}"
}

resource "google_service_account_iam_member" "sa-user-iam" {
  for_each           = var.sa_users
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "group:${var.sa_user_group}"
}

resource "google_service_account_iam_member" "sa-tokenCreator-iam" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "group:${var.sa_user_group}"
}