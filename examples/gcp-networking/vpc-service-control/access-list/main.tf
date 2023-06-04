data "terraform_remote_state" "access-policy" {
  backend = "gcs"

  config = {
    bucket = "bucket-name-tfstate"
    prefix = "terraform/access-policy-state"
  }
}
module "access-level-parimeters" {
  source = "../../../modules/gcp-networking/service-parimeters/access-level-parimeter"

  access_levels = {
    "de_infra_team_access" = {
      policy               = data.terraform_remote_state.access-policy.outputs.module_policy_ids["tf-project-policy"]
      name                 = "Infra_Team_Access"
      geographical_regions = ["DE"]
      ip_subnetworks       = ["192.88.100.0/24", "192.95.89.0/24"]
    },
    "de_data_team_access" = {
      policy               = data.terraform_remote_state.access-policy.outputs.module_policy_ids["service-parimeter4-project-policy"]
      name                 = "Data_Team_Access"
      geographical_regions = ["DE"]
      ip_subnetworks       = ["192.88.100.0/24", "192.95.89.0/24"]
    }
  }
}
