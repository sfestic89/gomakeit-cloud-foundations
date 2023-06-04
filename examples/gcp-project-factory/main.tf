# For injecting the folder id
data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = "bucketName"
    prefix = "terraform/bootstrap/state"
  }
}

module "prj-factory" {
  source = "../../modules/gcp-project-factory"

  monitoring-prj-name = "prj-factory-test"

  project_configs = [{
    folder_id = split("/", data.terraform_remote_state.bootstrap.outputs.common_config.common_folder_name)[1]

    project_name       = ""
    project_id         = ""
    billing_account_id = ""
    labels = {
      "business-code" : "",
      "billing-code" : "",
      "primary-contact" : "",
      "secondary-contact" : "",
      "environment" : ""
    }
    apis = [
      "logging.googleapis.com",
      "cloudresourcemanager.googleapis.com",
      "cloudbilling.googleapis.com",
      "storage-api.googleapis.com",
    ]

    budget_amount        = 100
    budget_currency_code = "EUR"
    budget_thresholds    = [0.2, 0.5, 0.75]
    budget_display_name  = ""

    is_monitoring_prj = true 

    notification_channels = {
      email : [
        { contact : "", display_name : "" },
      ]
    }
    },
    {
      folder_id = split("/", data.terraform_remote_state.bootstrap.outputs.common_config.common_folder_name)[1]

      project_name       = ""
      project_id         = ""
      billing_account_id = ""
      labels = {
        "business-code" : "",
        "billing-code" : "",
        "primary-contact" : "",
        "secondary-contact" : "",
        "environment" : ""
      }
      apis = [

        "cloudresourcemanager.googleapis.com",
        "cloudbilling.googleapis.com",

      ]
      budget_config = {
        amount        = 10
        currency_code = "EUR"
        thresholds    = [0.2, 0.5, 0.75]
        name          = "all_projects_all_services"
      }



      notification_channels = {
        email : [
          { contact : "", display_name : "" },
        ]
      }
    },
  ]

}