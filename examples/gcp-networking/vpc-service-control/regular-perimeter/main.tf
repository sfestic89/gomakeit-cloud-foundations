data "terraform_remote_state" "access-policy" {
  backend = "gcs"

  config = {
    bucket = "bucket-name-tfstate"
    prefix = "terraform/access-policy-state"
  }
}

data "terraform_remote_state" "access-list" {
  backend = "gcs"

  config = {
    bucket = "bucket-name-tfstate"
    prefix = "terraform/access-level-state"
  }
}

module "regular_service_perimeter" {
  source = "../../../modules/gcp-networking/service-parimeters/regular-service-parimeter"

  resources               = ["985144135014"]
  parent                  = "accessPolicies/${data.terraform_remote_state.access-policy.outputs.module_policy_ids["tf-project-policy"]}"
  description             = "My regular service perimeter"
  title                   = "perimeter_1"
  restricted_services     = ["bigquery.googleapis.com"]
  access_levels           = [data.terraform_remote_state.access-list.outputs.module_access_level_names["de_infra_team_access"]]
  vpc_accessible_services = ["bigquery.googleapis.com"]
  ingress_policies = [
    {
      ingress_from = {
        sources       = []
        identities    = []
        identity_type = "ANY_IDENTITY"
      }
      ingress_to = {
        resources = []
        operations = {
          "bigquery.googleapis.com" = {
            method_selectors = [
              {
                #method     = "BigQueryStorage.ReadRows"
                permission = "bigquery.datasets.create"
              },
            ]
          }
        }
      }
    }
  ]
  egress_policies = [
    {
      egress_from = {
        identity_type = "ANY_IDENTITY"
      }
    }
  ]
}

#resource = "985144135014"
/* service_perimeters = {
    "perimeter1" = {
      parent              = "accessPolicies/${data.terraform_remote_state.access-policy.outputs.module_policy_ids["tf-project-policy"]}"
      title               = "Perimeter 1"
      access_level        = data.terraform_remote_state.access-list.outputs.module_access_level_names["de_infra_team_access"]
      restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]

      status = {
        restricted_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
        access_level        = data.terraform_remote_state.access-list.outputs.module_access_level_names["de_infra_team_access"]

        ingress_policies = [
          {
            ingress_from = {
              sources = [
                {
                  resource     = "terraform-project-385615"
                  access_level = data.terraform_remote_state.access-list.outputs.module_access_level_names["de_infra_team_access"]
                },
              ]
              identity_type = "ANY_IDENTITY"
            }
            ingress_to = {
              resources = ["*"]
              operations = [
                {
                  service_name = "bigquery.googleapis.com"
                  method_selectors = [
                    {
                      #method     = "BigQueryStorage.ReadRows"
                      permission = "bigquery.datasets.create"
                    },
                  ]
                },
              ]
            }
          },
        ]

        egress_policies = [
          {
            egress_from = {
              identity_type = "ANY_USER_ACCOUNT"
            }
          },
        ]

        vpc_accessible_services = {
          allowed_services = ["bigquery.googleapis.com", "storage.googleapis.com"]
        }
      }
    }
  } */
