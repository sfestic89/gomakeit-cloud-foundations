# Configure Workload Identity Federation for GitHub
module "bootstrap_wif" {
  source     = "../../modules/gcp-bootstrap/wif"
  project_id = module.seed_bootstrap.project_ids["seed-project"]

  repository_type = "GITHUB"
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
  }

  attribute_validation = {
    "attribute.repository" = "ORGANIZATION/REPOSITORY"
  }

  oidc = {
    allowed_audiences = []
    issuer_uri        = "https://token.actions.githubusercontent.com"
  }

  wif_pool_display_name      = "WIF Pool Landing Zone - GITHUB"
  wif_pool_description       = "Workload Identity Federation Pool for the Landing Zone using GitHub"
  wif_service_account_emails = [for k, v in local.sa_emails : "${v}"]
}

# Configure Workload Identity Federation for GitLab
# module "bootstrap_wif" {
#   source     = "../../modules/gcp-bootstrap/wif"
#   project_id = module.seed_bootstrap.project_ids["seed-project"]

#   repository_type = "GITLAB"
#   attribute_mapping = {
#     "google.subject"         = "assertion.sub"
#     "attribute.project_path" = "assertion.project_path"
#   }

#   attribute_validation = {
#     "attribute.project_path" = "GROUP/PROJECT"
#   }

#   oidc = {
#     allowed_audiences = ["https://gitlab.com"] # GitLab instance URL (as list)
#     issuer_uri        = "https://gitlab.com/"  # GitLab instance URL (as string with trailing slash)
#   }

#   wif_pool_display_name = "WIF Pool Landing Zone - GITLAB"
#   wif_pool_description  = "Workload Identity Federation Pool for the Landing Zone using GitLab"
#   wif_service_account_emails = [for k, v in local.sa_emails : "${v}"]

# }

# Configure Workload Identity Federation for BitBucket
# module "bootstrap_wif" {
#   source     = "../../modules/gcp-bootstrap/wif"
#   project_id = module.seed_bootstrap.project_ids["seed-project"]

#   repository_type = "BITBUCKET"
#   attribute_mapping = {
#     "google.subject"            = "assertion.sub"
#     "attribute.repository_uuid" = "assertion.repositoryUuid"
#   }

#   attribute_validation = {
#     "attribute.repository_uuid" = "{REPOSITORY_UUID}" # Replace REPOSITORY_UUID with the Repository UUID value, keep curly braces
#   }

#   oidc = {
#     allowed_audiences = ["ari:cloud:bitbucket::workspace/WORKSPACE_UUID"]                                        # Replace WORKSPACE_UUID with the Workspace UUID value
#     issuer_uri        = "https://api.bitbucket.org/2.0/workspaces/WORKSPACE_NAME/pipelines-config/identity/oidc" # Replace WORKSPACE_NAME with the Workspace name
#   }

#   wif_pool_display_name = "WIF Pool Landing Zone - BITBUCKET"
#   wif_pool_description  = "Workload Identity Federation Pool for the Landing Zone using Bitbucket"
#   wif_service_account_emails = [for k, v in local.sa_emails : "${v}"]

# }
