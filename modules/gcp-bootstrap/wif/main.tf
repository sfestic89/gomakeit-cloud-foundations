/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  attribute_validation = join("/", [for k, v in var.attribute_validation : "${k}/${v}"])
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

data "google_project" "project" {
  project_id = var.project_id
}

# Workload Identity Federation Pool
resource "google_iam_workload_identity_pool" "wif_pool" {
  project = var.project_id

  workload_identity_pool_id = "wif-pool-${random_string.suffix.result}"
  display_name              = var.wif_pool_display_name
  description               = var.wif_pool_description
  disabled                  = false
}

# Workload Identity Federation Pool Provider
resource "google_iam_workload_identity_pool_provider" "oidc_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.wif_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "wif-provider-${lower(var.repository_type)}-${random_string.suffix.result}"
  display_name                       = "WIF Provider ${var.repository_type}"
  description                        = "Workload Identity Federation Pool Provider for ${var.repository_type}"
  disabled                           = false

  attribute_mapping = var.attribute_mapping

  oidc {
    allowed_audiences = var.oidc.allowed_audiences
    issuer_uri        = var.oidc.issuer_uri
  }
}

resource "google_service_account_iam_member" "wif_oidc_iam" {
  count              = length(var.wif_service_account_emails)
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.wif_service_account_emails[count.index]}"
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${google_iam_workload_identity_pool.wif_pool.workload_identity_pool_id}/${local.attribute_validation}"
}
