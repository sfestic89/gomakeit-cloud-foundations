output "seed_project_id" {
  description = "Project where service accounts and core APIs will be enabled."
  value       = module.seed_bootstrap.project_ids["seed-project"]
}

output "bootstrap_step_terraform_service_account_email" {
  description = "Bootstrap Step Terraform Account"
  value       = local.sa_emails["bootstrap"]
}

output "projects_step_terraform_service_account_email" {
  description = "Projects Step Terraform Account"
  value       = local.sa_emails["proj"]
}

output "networks_step_terraform_service_account_email" {
  description = "Networks Step Terraform Account"
  value       = local.sa_emails["net"]
}

output "environment_step_terraform_service_account_email" {
  description = "Environment Step Terraform Account"
  value       = local.sa_emails["env"]
}

output "organization_step_terraform_service_account_email" {
  description = "Organization Step Terraform Account"
  value       = local.sa_emails["org"]
}

output "gcs_bucket_tfstate" {
  description = "Bucket used for storing terraform state for Foundations Pipelines in Seed Project."
  value       = module.gcs_bucket_tfstate.name
}

output "common_config" {
  description = "Common configuration data to be used in other steps."
  value = {
    org_id                = local.org_id,
    billing_account       = local.billing_account,
    default_region        = local.default_region,
    project_prefix        = local.project_prefix,
    folder_prefix         = local.folder_prefix
    parent_id             = local.parent
    bootstrap_folder_name = module.folders_l1_shared.folder_ids["l1-shared-bootstrap"]
    common_folder_name    = module.folders_l1_shared.folder_ids["l1-shared-common"]
    folders = {
      folders_root      = module.folders_root.folder_ids
      folders_l1_shared = module.folders_l1_shared.folder_ids
      folders_l1_global = module.folders_l1_global.folder_ids
    }
  }
}

output "group_org_admins" {
  description = "Google Group for GCP Organization Administrators."
  value       = local.group_org_admins
}

output "group_billing_admins" {
  description = "Google Group for GCP Billing Administrators."
  value       = local.group_billing_admins
}

output "required_groups" {
  description = "List of Google Groups created that are required by the Foundation steps."
  value       = local.groups.create_groups == true ? module.required_group : {}
}

output "optional_groups" {
  description = "List of Google Groups created that are optional to the Foundation steps."
  value       = local.groups.create_groups == true ? module.optional_group : {}
}

output "workload_identity_pool_provider_resource_name" {
  description = "Workload Identity Federation pool provider resource name."
  value       = module.bootstrap_wif.workload_identity_pool_provider_resource_name
}

output "git_repository_type" {
  description = "Type of git repository used to store the source code."
  value       = module.bootstrap_wif.repository_type
}
