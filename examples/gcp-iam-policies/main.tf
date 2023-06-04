######################################################
######### ORG LEVEL IAM ROLES AND PERMISSIONS ##########
module "org-iam" {
  source = "../modules/gcp-iam-permissions/gcp-org-iam"
  org_role_members = {
    "roles/compute.networkAdmin"            = ["group:network-admin@gomakeit.net", "user:sfestic@gomakeit.net"]
    "roles/servicenetworking.networksAdmin" = ["group:network-admin@gomakeit.net", "user:sfestic@gomakeit.net"]
    "roles/compute.xpnAdmin"                = ["group:network-admin@gomakeit.net", "user:sfestic@gomakeit.net"]
    "roles/logging.viewer"                  = ["group:network-admin@gomakeit.net", "user:sfestic@gomakeit.net"]
    "roles/compute.securityAdmin"           = ["group:network-admin@gomakeit.net", "group:security-admin@gomakeit.net"]
    "roles/compute.orgSecurityPolicyAdmin"  = ["group:network-admin@gomakeit.net", "user:sfestic@gomakeit.net"]
    "roles/billing.admin"                   = ["group:billing-admin@gomakeit.net", "user:sfestic@gomakeit.net"]
    #"roles/resourcemanager.organizationAdmin" = ["group:org-admin@gomakeit.net", "serviceAccount:bootstrap-tf-sa@bootstrap-lz-2.iam.gserviceaccount.com", "user:sfestic@gomakeit.net"]
  }
}

######################################################
######### FOLDERS IAM ROLES AND PERMISSIONS ##########

/*FOLDER ROLES AND PERMISSIONS */
module "gomakeit-test-folder-iam" {
  source = "../modules/gcp-iam-permissions/gcp-folder-iam"

  folder_iam_role_bindings = {
    "49688988529" = {
      "roles/resourcemanager.folderAdmin"   = ["group:infra-admin@gomakeit.net"],
      "roles/resourcemanager.folderCreator" = ["group:infra-admin@gomakeit.net"],
      "roles/resourcemanager.folderEditor"  = ["group:security-admin@gomakeit.net", "user:sfestic@gomakeit.net"],
    },
    

  }
}

######################################################
######### PROJECTS IAM ROLES AND PERMISSIONS ##########
module "gcp-projects-iam" {
  source = "../modules/gcp-iam-permissions/gcp-project-iam"

  project_iam_role_bindings = {
    "project_ID" = {
      "roles/resourcemanager.folderAdmin"   = ["group:infra-admin@gomakeit.net"],
      "roles/resourcemanager.folderCreator" = ["group:infra-admin@gomakeit.net"],
      "roles/resourcemanager.folderEditor"  = ["group:security-admin@gomakeit.net", "user:sfestic@gomakeit.net"],
    }

  }
}

#######################################################
######### GCS BUCKET IAM ROLES AND PERMISSIONS ########
module "gcs-bucket-iam" {
  source = "../modules/gcp-iam-permissions/gcs-bucket-iam"

  bucket_iam_role_bindings = {
    "bucket_ID" = {
      "roles/resourcemanager.folderAdmin"   = ["group:infra-admin@gomakeit.net"],
      "roles/resourcemanager.folderCreator" = ["group:infra-admin@gomakeit.net"],
      "roles/resourcemanager.folderEditor"  = ["group:security-admin@gomakeit.net", "user:sfestic@gomakeit.net"],
    }

  }
}
