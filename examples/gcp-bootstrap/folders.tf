/******************************************
  Folder structure
 *****************************************/

# Folders to be created at the top level (root)
module "folders_root" {
  source = "../../modules/gcp-folders"

  folders = {
    "root-shared" = {
      parent       = local.parent
      display_name = "${local.folder_prefix}Shared"
    }
    "root-global" = {
      parent       = local.parent
      display_name = "${local.folder_prefix}Global"
    }
  }
}

# Level 1 folders (root folder as parent)
# Child folders for shared
module "folders_l1_shared" {
  source = "../../modules/gcp-folders"

  folders = {
    "l1-shared-bootstrap" = {
      parent       = module.folders_root.folder_ids["root-shared"]
      display_name = "${local.folder_prefix}Bootstrap"
    }
    "l1-shared-common" = {
      parent       = module.folders_root.folder_ids["root-shared"]
      display_name = "${local.folder_prefix}Common"
    }
  }
}

# Child folders for global
module "folders_l1_global" {
  source = "../../modules/gcp-folders"

  folders = {
    "l1-global-de" = {
      parent       = module.folders_root.folder_ids["root-global"]
      display_name = "${local.folder_prefix}DE"
    }
  }
}

# Child folders for DE
module "folders_l2_de" {
  source = "../../modules/gcp-folders"

  folders = {
    "l2-de-product-a" = {
      parent       = module.folders_l1_global.folder_ids["l1-global-de"]
      display_name = "${local.folder_prefix}Product-a"
    }
    "l2-de-product-b" = {
      parent       = module.folders_l1_global.folder_ids["l1-global-de"]
      display_name = "${local.folder_prefix}Product-b"
    }
  }
}
