terraform {
  backend "gcs" {
    bucket = "bucket-name-tf-state"
    prefix = "terraform/iam-policy-state"
  }
}
