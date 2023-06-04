/*****************
  GCS IAM Binding
 *****************/
locals {

  helper_list = flatten([for bucket, value in var.gcs_iam_role_bindings :
    flatten([for role, roles in value :
      [for member in roles :
        { "member" = member
          "bucket" = bucket
          "role" = role 
        }
    ]])
  ])
}
resource "google_folder_iam_binding" "folder_iam_binding" {
  for_each = { for idx, record in local.helper_list : idx => record }

  bucket = each.value.bucket
  role   = each.value.role

  members = [each.value.member]
}
