/*****************
  Project IAM Binding
 *****************/
locals {

  helper_list = flatten([for project, value in var.project_iam_role_bindings :
    flatten([for role, roles in value :
      [for member in roles :
        { "member" = member
          "project" = project
          "role" = role 
        }
    ]])
  ])
}
resource "google_project_iam_binding" "project_iam_binding" {
  for_each = { for idx, record in local.helper_list : idx => record }

  project = each.value.project
  role   = each.value.role

  members = [each.value.member]
}
