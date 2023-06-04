<!-- BEGIN_TF_DOCS -->
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_iam_workload_identity_pool.wif_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool) | resource |
| [google_iam_workload_identity_pool_provider.oidc_provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider) | resource |
| [google_service_account_iam_member.wif_oidc_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_attribute_mapping"></a> [attribute\_mapping](#input\_attribute\_mapping) | Attribute mapping | `map(string)` | n/a | yes |
| <a name="input_attribute_validation"></a> [attribute\_validation](#input\_attribute\_validation) | Map with attributes to be validated and its matching value | `map(string)` | n/a | yes |
| <a name="input_oidc"></a> [oidc](#input\_oidc) | OIDC configuration | <pre>object({<br>    allowed_audiences = list(string)<br>    issuer_uri        = string<br>  })</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID where resources will be created in | `string` | n/a | yes |
| <a name="input_repository_type"></a> [repository\_type](#input\_repository\_type) | Type of the Git platform used to host the source code and run the CI/CD pipelines | `string` | n/a | yes |
| <a name="input_wif_pool_description"></a> [wif\_pool\_description](#input\_wif\_pool\_description) | Workload Identity Federation Pool description | `string` | n/a | yes |
| <a name="input_wif_pool_display_name"></a> [wif\_pool\_display\_name](#input\_wif\_pool\_display\_name) | Workload Identity Federation Pool display name | `string` | n/a | yes |
| <a name="input_wif_service_account_emails"></a> [wif\_service\_account\_emails](#input\_wif\_service\_account\_emails) | Service Account emails that will have access to the Workload Identity Federation Pool/Provider | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workload_identity_pool_provider_resource_name"></a> [workload\_identity\_pool\_provider\_resource\_name](#output\_workload\_identity\_pool\_provider\_resource\_name) | Workload Identity Federation pool provider resource name. |
<!-- END_TF_DOCS -->