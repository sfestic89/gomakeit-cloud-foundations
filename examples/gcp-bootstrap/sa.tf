locals {

  parent_type = length(split("organizations/", local.parent)) > 1 ? "organization" : "folder"
  parent_id   = local.parent

  granular_sa = {
    "bootstrap" = "Foundation Bootstrap SA. Managed by Terraform.",
    "org"       = "Foundation Organization SA. Managed by Terraform.",
    "env"       = "Foundation Environment SA. Managed by Terraform.",
    "net"       = "Foundation Network SA. Managed by Terraform.",
    "proj"      = "Foundation Projects SA. Managed by Terraform.",
  }

  sa_emails = {
    "bootstrap" = module.terraform-env-sa["bootstrap"].sa_emails["bootstrap"],
    "org"       = module.terraform-env-sa["org"].sa_emails["org"],
    "env"       = module.terraform-env-sa["env"].sa_emails["env"],
    "net"       = module.terraform-env-sa["net"].sa_emails["net"],
    "proj"      = module.terraform-env-sa["proj"].sa_emails["proj"],
  }

  common_roles = [
    "roles/browser", // Required for gcloud beta terraform vet to be able to read the ancestry of folders
  ]

  granular_sa_org_level_roles = {
    "bootstrap" = distinct(concat([
      "roles/resourcemanager.organizationAdmin",
      "roles/accesscontextmanager.policyAdmin",
      "roles/serviceusage.serviceUsageConsumer",
    ], local.common_roles)),
    "org" = distinct(concat([
      "roles/orgpolicy.policyAdmin",
      "roles/logging.configWriter",
      "roles/resourcemanager.organizationAdmin",
      "roles/securitycenter.notificationConfigEditor",
      "roles/resourcemanager.organizationViewer",
      "roles/accesscontextmanager.policyAdmin",
      "roles/essentialcontacts.admin",
      "roles/resourcemanager.tagAdmin",
      "roles/resourcemanager.tagUser",
    ], local.common_roles)),
    "env" = distinct(concat([
      "roles/resourcemanager.tagUser",
    ], local.common_roles)),
    "net" = distinct(concat([
      "roles/accesscontextmanager.policyAdmin",
      "roles/compute.xpnAdmin",
    ], local.common_roles)),
    "proj" = distinct(concat([
      "roles/accesscontextmanager.policyAdmin",
      "roles/resourcemanager.organizationAdmin",
      "roles/serviceusage.serviceUsageConsumer",
    ], local.common_roles)),
  }

  granular_sa_parent_level_roles = {
    "bootstrap" = [
      "roles/resourcemanager.folderAdmin",
    ],
    "org" = [
      "roles/resourcemanager.folderAdmin",
    ],
    "env" = [
      "roles/resourcemanager.folderAdmin"
    ],
    "net" = [
      "roles/resourcemanager.folderViewer",
      "roles/compute.networkAdmin",
      "roles/compute.securityAdmin",
      "roles/compute.orgSecurityPolicyAdmin",
      "roles/compute.orgSecurityResourceAdmin",
      "roles/dns.admin",
    ],
    "proj" = [
      "roles/resourcemanager.folderViewer",
      "roles/resourcemanager.folderIamAdmin",
      "roles/artifactregistry.admin",
      "roles/compute.networkAdmin",
      "roles/compute.xpnAdmin",
    ],
  }

  // Roles required to manage resources in the Seed project
  granular_sa_seed_project = {
    "bootstrap" = [
      "roles/storage.admin",
      "roles/iam.serviceAccountAdmin",
      "roles/resourcemanager.projectDeleter",
      "roles/iam.workloadIdentityPoolAdmin"
    ],
    "org" = [
      "roles/storage.objectAdmin",
    ],
    "env" = [
      "roles/storage.objectAdmin"
    ],
    "net" = [
      "roles/storage.objectAdmin",
    ],
    "proj" = [
      "roles/storage.objectAdmin",
    ],
  }
}

module "terraform-env-sa" {
  source = "../../modules/gcp-service-accounts"

  for_each = local.granular_sa

  service_accounts = {
    (each.key) = {
      project      = module.seed_bootstrap.project_ids["seed-project"]
      account_id   = "sa-terraform-${each.key}"
      display_name = each.value
      description  = each.value
    }
  }
}

module "org_iam_member" {
  source   = "../../modules/gcp-bootstrap/parent-iam-member"
  for_each = local.granular_sa_org_level_roles

  member      = "serviceAccount:${module.terraform-env-sa[each.key].sa_emails[each.key]}"
  parent_type = "organization"
  parent_id   = local.org_id
  roles       = each.value
}

module "parent_iam_member" {
  source   = "../../modules/gcp-bootstrap/parent-iam-member"
  for_each = local.granular_sa_parent_level_roles

  member      = "serviceAccount:${module.terraform-env-sa[each.key].sa_emails[each.key]}"
  parent_type = local.parent_type
  parent_id   = local.parent_id
  roles       = each.value
}

module "seed_project_iam_member" {
  source   = "../../modules/gcp-bootstrap/parent-iam-member"
  for_each = local.granular_sa_seed_project

  member      = "serviceAccount:${module.terraform-env-sa[each.key].sa_emails[each.key]}"
  parent_type = "project"
  parent_id   = module.seed_bootstrap.project_ids["seed-project"]
  roles       = each.value
}

resource "google_billing_account_iam_member" "tf_billing_user" {
  for_each = local.granular_sa

  billing_account_id = local.billing_account
  role               = "roles/billing.user"
  member             = "serviceAccount:${module.terraform-env-sa[each.key].sa_emails[each.key]}"

  depends_on = [
    module.terraform-env-sa.sa_emails
  ]
}

resource "google_billing_account_iam_member" "billing_admin_user" {
  for_each = local.granular_sa

  billing_account_id = local.billing_account
  role               = "roles/billing.admin"
  member             = "serviceAccount:${module.terraform-env-sa[each.key].sa_emails[each.key]}"

  depends_on = [
    google_billing_account_iam_member.tf_billing_user
  ]
}
