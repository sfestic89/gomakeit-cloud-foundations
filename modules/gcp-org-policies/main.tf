locals {
  org_id = "XXXXXXXXXX"
}
################################################################
############### BOOL CONSTRAINTS ###############################
resource "google_organization_policy" "all_org_policy_boolean" {
  for_each   = var.boolean_policy
  org_id     = local.org_id
  constraint = each.value
  boolean_policy {
    enforced = true
  }
}

################################################################
############### LIST CONSTRAINTS ###############################
resource "google_organization_policy" "all_org_policy_list" {
  org_id     = local.org_id
  for_each   = var.list_policies
  constraint = each.value.constraint

  dynamic "list_policy" {
    for_each = each.value.list_type == "allow" ? [true] : [false]

    content {
      dynamic "allow" {
        for_each = each.value.list_type == "allow" ? each.value.list_values : []
        content {
          values = [allow.value]
        }
      }

      dynamic "deny" {
        for_each = each.value.list_type == "deny" ? each.value.list_values : []
        content {
          values = [deny.value]
        }
      }
    }
  }
}
