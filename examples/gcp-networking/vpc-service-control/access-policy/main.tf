module "access-policy" {
  source = "../../../modules/gcp-networking/service-parimeters/access-policy"

  access_policies = {
    "tf-project-policy" = {
      parent = "organizations/XXXXXXXX"
      title  = "Terraform Project Policy"
      scopes = ["projects/XXXXXXXX"]
    },
    "service-parimeter1-project-policy" = {
      parent = "organizations/XXXXXXXX"
      title  = "Service Parimeter Project Policy 1"
      scopes = ["projects/XXXXXXXX"]
    },
    "service-parimeter2-project-policy" = {
      parent = "organizations/XXXXXXXX"
      title  = "Service Parimeter Project Policy 2"
      scopes = ["projects/XXXXXXXX"]
    },
    "service-parimeter3-project-policy" = {
      parent = "organizations/XXXXXXXX"
      title  = "Service Parimeter Project Policy 3"
      scopes = ["projects/XXXXXXXX"]
    },
    "service-parimeter4-project-policy" = {
      parent = "organizations/XXXXXXXX"
      title  = "Service Parimeter Project Policy 4"
      scopes = ["projects/XXXXXXXX"]
    }
  }
}
