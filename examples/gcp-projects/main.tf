data "terraform_remote_state" "root-folder-structure" {
  backend = "gcs"

  config = {
    bucket = "gomakeit-tf-state"
    prefix = "terraform/folder-state"
  }
}

module "gcp_projects" {
  source = "../modules/gcp-projects"

  projects = {
    "sit-crm-gomakeit-1" = {
      name            = "sit-crm-org-name-prj-1"
      project_id      = "sit-crm-org-name-prj"
      billing_account = "XXXXXXXXX"
      #folder_id       = "folders/XXXXXXXXXXXXX"
      folder_id = data.terraform_remote_state.root-folder-structure.outputs.ids["folder_ids"]["dev-env-org-name"]
    }
    "prod-crm-gomakeit-1" = {
      name            = "prod-crm-org-name-prj-1"
      project_id      = "prod-crm-org-name-prj"
      billing_account = "XXXXXXXXXX"
      #folder_id       = "folders/XXXXXXXXX"
      folder_id = data.terraform_remote_state.root-folder-structure.outputs.ids["folder_ids"]["prod-env-org-name"]
    }
    "test-crm-gomakeit-1" = {
      name            = "test-crm-org-name-prj-1"
      project_id      = "test-crm-org-name-prj"
      billing_account = "XXXXXXXXXXXXXX"
      #folder_id = data.terraform_remote_state.root-folder-structure.outputs.ids["folder_ids"]["test-env-org-name"]
      folder_id = "" # if empty, it will take ORG ID
    }
  }
}
