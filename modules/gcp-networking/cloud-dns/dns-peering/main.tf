resource "google_dns_managed_zone" "peering_zone" {
  for_each    = { for peering_zone, peering_zones in var.peering_zone_name : peering_zone => peering_zones }
  project     = each.value.project
  name        = each.value.name
  dns_name    = each.value.dns_name
  description = each.value.description

  force_destroy = var.force_destroy

  private_visibility_config {
    dynamic "networks" {
      for_each = each.value.network_url
      content {
        network_url = networks.value
      }
    }
  }
  peering_config {
    target_network {
      network_url = each.value.target_network_url
    }
  }
}
