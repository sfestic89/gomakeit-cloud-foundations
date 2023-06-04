data "terraform_remote_state" "access-policy" {
  backend = "gcs"

  config = {
    bucket = "gomakeit-tfstate"
    prefix = "terraform/access-policy-state"
  }
}

data "terraform_remote_state" "access-list" {
  backend = "gcs"

  config = {
    bucket = "gomakeit-tfstate"
    prefix = "terraform/access-level-state"
  }
}

module "bridge_service_perimeter" {
  source = "../../../modules/gcp-networking/service-parimeters/bridge-service-parimeter"

  bridge_perimeters = {
    "perimeter1" = {
      parent       = "accessPolicies/${data.terraform_remote_state.access-policy.outputs.module_policy_ids["XXXXXXXX"]}"
      title        = "Bridge Perimeter Name"
      access_level = data.terraform_remote_state.access-list.outputs.module_access_level_names["XXXXXXXX"]
      status = {
        resources    = ["XXXXXXXX"]
      }
    }
  }
}
