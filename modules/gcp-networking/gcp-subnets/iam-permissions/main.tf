/*****************
  Subnet IAM Permissions
 *****************/
locals {
  helper_list = flatten([
    for project, project_data in var.subnet_iam_permissions : [
      for subnetwork, subnetwork_data in project_data : [
        for role, role_data in subnetwork_data : [
          for member in role_data.members : {
            project    = project
            subnetwork = subnetwork
            role       = role
            member     = member
            region     = role_data.region
          }
        ]
      ]
    ]
  ])
}
resource "google_compute_subnetwork_iam_member" "subnetwork_member" {
  for_each = { for idx, record in local.helper_list : idx => record }

  subnetwork = each.value.subnetwork
  role       = each.value.role
  project    = each.value.project
  member     = each.value.member
  region     = tostring(each.value.region)

}
