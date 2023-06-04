#Groups creation resources
locals {
  optional_groups_to_create = {
    for key, value in local.groups.optional_groups : key => value
    if value != "" && local.groups.create_groups == true
  }
  required_groups_to_create = {
    for key, value in local.groups.required_groups : key => value
    if local.groups.create_groups == true
  }
}

data "google_organization" "org" {
  count        = local.groups.create_groups ? 1 : 0
  organization = local.org_id
}

module "required_group" {
  for_each = local.required_groups_to_create
  source   = "../../modules/gcp-groups/identity-group"

  parent       = "customers/${data.google_organization.org[0].directory_customer_id}"
  display_name = each.value.display_name
  description  = each.value.description
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" : ""
  }

  group_key = {
    id = each.value.id
  }

  initial_group_config = "WITH_INITIAL_OWNER"
}

module "optional_group" {
  for_each = local.optional_groups_to_create
  source   = "../../modules/gcp-groups/identity-group"

  parent       = "customers/${data.google_organization.org[0].directory_customer_id}"
  display_name = each.value.display_name
  description  = each.value.description
  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" : ""
  }
  group_key = {
    id = each.value.id
  }

  initial_group_config = "WITH_INITIAL_OWNER"
}
