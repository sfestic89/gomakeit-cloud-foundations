module "root-folder-structure" {
  source = "../modules/gcp-folders"
  folders = {
    "dev-env-org-name" = {
      display_name = "dev-env-org-name"
      parent       = "organizations/XXXXXX"
    }
    "dev-crm-org-name" = {
      display_name = "dev-crm-org-name"
      parent       = "folders/XXXXXX"
    }
    "test-env-org-name" = {
      display_name = "test-env-org-name"
      parent       = "organizations/XXXXXX"
    }
    "test-crm-org-name" = {
      display_name = "test-crm-org-name"
      parent       = "folders/XXXXXX"
    }
    "prod-env-org-name" = {
      display_name = "prod-env-org-name"
      parent       = "organizations/XXXXXX"
    }
    "prod-crm-org-name" = {
      display_name = "prod-crm-org-name"
      parent       = "folders/XXXXXX"
    }
    "shared-svc-org-name" = {
      display_name = "shared-svc-org-name"
      parent       = "organizations/XXXXXX"
    }
  }
}
