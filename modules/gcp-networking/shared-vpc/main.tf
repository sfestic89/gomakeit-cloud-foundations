/**************************************
  Enablement of the Shared VPC Project
 **************************************/
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.project_id
}

/********************************************************
  Attachment of the service projects to the host project
 ********************************************************/
resource "google_compute_shared_vpc_service_project" "service" {
  for_each        = toset(var.service_projects_list)
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = each.key
}
