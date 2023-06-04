terraform {
  backend "gcs" {
    bucket = "gomakeit-tfstate"
    prefix = "terraform/access-policy-state"
  }
}
