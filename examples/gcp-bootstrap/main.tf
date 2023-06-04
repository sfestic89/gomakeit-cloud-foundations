/*************************************************
  Bootstrap GCP Organization.
*************************************************/
locals {
  org_id = "XXXXXXX"
  parent = "folders/XXXXXX" # Deploy the LZ at folder level
  #parent               = "organizations/${local.org_id}" # Deploy the LZ at org level

  # Prefixes
  folder_prefix  = ""
  project_prefix = "prj"
  bucket_prefix  = ""

  # Billing Account
  billing_account = "000000-000000-000000"

  # Region
  default_region = "europe-west3"

  step_terraform_sa = [
    "serviceAccount:${local.sa_emails["bootstrap"]}",
    "serviceAccount:${local.sa_emails["org"]}",
    "serviceAccount:${local.sa_emails["env"]}",
    "serviceAccount:${local.sa_emails["net"]}",
    "serviceAccount:${local.sa_emails["proj"]}",
  ]
  org_policy_admin_role = true
  org_project_creators  = local.step_terraform_sa
  org_admins_org_iam_permissions = local.org_policy_admin_role == true ? [
    "roles/orgpolicy.policyAdmin", "roles/resourcemanager.organizationAdmin", "roles/billing.user"
  ] : ["roles/resourcemanager.organizationAdmin", "roles/billing.user"]

  group_org_admins     = local.groups.required_groups.gcp_org_admin
  group_billing_admins = local.groups.required_groups.gcp_billing_admin

  groups = {
    create_groups = false # Set true to create the following groups
    required_groups = {
      gcp_audit_viewer = {
        id           = "grp-gcp-audit-viewer@dev.devoteam.de"
        display_name = "GCP Audit Viewer"
        description  = "Members are part of an audit team and view audit logs in the logging project."
      }
      gcp_billing_admin = {
        id           = "grp-gcp-billing-admin@dev.devoteam.de"
        display_name = "GCP Billing Admin"
        description  = "GCP Billing Admin Identity that has billing administrator permissions within the organization."
      }
      gcp_billing_creator = {
        id           = "grp-gcp-billing-creator@dev.devoteam.de"
        display_name = "GCP Billing Creator"
        description  = "Identity that can create billing accounts."
      }
      gcp_billing_viewer = {
        id           = "grp-gcp-billing-viewer@dev.devoteam.de"
        display_name = "GCP Billing Viewer"
        description  = "Members are authorized to view the spend on projects. Typical members are part of the finance team."
      }
      gcp_global_secrets_admin = {
        id           = "grp-gcp-secrets-admin@dev.devoteam.de"
        display_name = "GCP Global Secrets Admin"
        description  = "Members are responsible for putting secrets into Secrets Manager."
      }
      gcp_network_viewer = {
        id           = "grp-gcp-network-viewer@dev.devoteam.de"
        display_name = "GCP Network Viewer"
        description  = "Members are part of the networking team and review network configurations."
      }
      gcp_org_admin = {
        id           = "grp-gcp-org-admin@dev.devoteam.de"
        display_name = "GCP Organization Admin"
        description  = "Identity that has organization administrator permissions within the organization."
      }
      gcp_platform_viewer = {
        id           = "grp-gcp-platform-viewer@dev.devoteam.de"
        display_name = "GCP Platform Viewer"
        description  = "Members have the ability to view resource information across the Google Cloud organization."
      }
      gcp_scc_admin = {
        id           = "grp-gcp-scc-admin@dev.devoteam.de"
        display_name = "GCP Security Command Center Admin"
        description  = "Members can administer Security Command Center."
      }
      gcp_scc_viewer = {
        id           = "grp-gcp-scc-viewer@dev.devoteam.de"
        display_name = "GCP Security Command Center Viewer"
        description  = "Members can view Security Command Center."
      }
      gcp_security_reviewer = {
        id           = "grp-gcp-security-reviewer@dev.devoteam.de"
        display_name = "GCP Security Reviewer"
        description  = "Members are part of the security team responsible for reviewing cloud security."
      }
    }
    optional_groups = {
      optional_group_1 = {
        id           = "test-grp-gcp-optional-group-1@dev.devoteam.de"
        display_name = "GCP Optional Group 1"
        description  = "Optional group 1."
      }
    }
  }
}

module "seed_bootstrap" {
  source = "../../modules/gcp-projects"

  folder_id = module.folders_l1_shared.folder_ids["l1-shared-bootstrap"]

  projects = {
    "seed-project" = {
      name            = "prj-b-seed"
      project_id      = "prj-b-seed"
      billing_account = local.billing_account

      # labels missing
      # apis missing
    }
  }
  depends_on = [
    module.folders_l1_shared
  ]
}

module "gcs_bucket_tfstate" {
  source = "../../modules/gcp-bootstrap/cloud-storage"

  name          = "bkt-b-tfstate-${module.seed_bootstrap.project_ids["seed-project"]}"
  project_id    = module.seed_bootstrap.project_ids["seed-project"]
  location      = local.default_region
  force_destroy = false
}
