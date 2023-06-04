resource "google_compute_network_peering" "peerings" {
  for_each = var.peerings  
  name         = each.value.name
  network      = each.value.network
  peer_network = each.value.peer_network
  export_custom_routes = true
  import_custom_routes = true
}
