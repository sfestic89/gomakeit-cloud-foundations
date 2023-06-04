resource "google_compute_network" "network" {
  for_each                = { for vpc, vpcs in var.vpc : vpc => vpcs }
  name                    = each.value.name
  auto_create_subnetworks = each.value.auto_create_subnetworks
  routing_mode            = each.value.routing_mode
  project                 = each.value.project
  description             = each.value.description
}
