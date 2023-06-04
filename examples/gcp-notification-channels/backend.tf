terraform {
  backend "gcs" {
    bucket = "bucket-name-tf-state"
    prefix = "terraform/project-state"
  }
}
