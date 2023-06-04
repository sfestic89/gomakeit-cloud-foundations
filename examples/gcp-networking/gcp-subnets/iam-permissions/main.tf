module "subnetwork_iam" {
  source = "../../../modules/gcp-networking/subnet-permissions"

  subnet_iam_permissions = {
    "project-1" = {
      "tf-subnet-1" = {
        "roles/compute.networkUser" = {
          members = ["group:name@domain"]
          region  = "add_region"
        },
        "roles/compute.networkViewer" = {
          members = ["group:name@domain"]
          region  = "add_region"
        }
      },
      "tf-subnet-2" = {
        "roles/compute.networkViewer" = {
          members = ["group:name@domain"]
          region  = "add_region"
        },
        "roles/compute.networkAdmin" = {
          members = ["group:name1@domain", "group:name2@domain"]
          region  = "add_region"
        }
      }
    },
    "project-2" = {
      "tf-subnet-3" = {
        "roles/compute.networkUser" = {
          members = ["group:name@domain"]
          region  = "add_region"
        },
        "roles/compute.networkViewer" = {
          members = ["group:name@domain"]
          region  = "add_region"
        }
      },
      "tf-subnet-4" = {
        "roles/compute.networkViewer" = {
          members = ["group:name@domain"]
          region  = "add_region"
        },
        "roles/compute.networkAdmin" = {
          members = ["group:name1@domain", "group:name2@domain"]
          region  = "add_region"
        }
      }
    },
  }
}
