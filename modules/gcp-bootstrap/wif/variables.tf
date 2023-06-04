/**
 * Copyright 2021 Google LLC
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

variable "project_id" {
  description = "Project ID where resources will be created in"
  type        = string
}

variable "repository_type" {
  description = "Type of the Git platform used to host the source code and run the CI/CD pipelines"
  type        = string
}

variable "wif_pool_display_name" {
  description = "Workload Identity Federation Pool display name"
  type        = string
}

variable "wif_pool_description" {
  description = "Workload Identity Federation Pool description"
  type        = string
}

variable "wif_service_account_emails" {
  description = "Service Account emails that will have access to the Workload Identity Federation Pool/Provider"
  type        = list(string)
}

variable "attribute_mapping" {
  description = "Attribute mapping"
  type        = map(string)
}

variable "attribute_validation" {
  description = "Map with attributes to be validated and its matching value"
  type        = map(string)
}

variable "oidc" {
  description = "OIDC configuration"
  type = object({
    allowed_audiences = list(string)
    issuer_uri        = string
  })
}





