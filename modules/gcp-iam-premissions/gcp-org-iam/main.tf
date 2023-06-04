/*****************
  Org IAM Binding
 *****************/
locals {
  org_id          = "XXXXXXXX"
}
resource "google_organization_iam_binding" "org_iam_binding" {
  for_each = var.org_role_members
  role     = each.key
  members  = each.value

  org_id = local.org_id
}

