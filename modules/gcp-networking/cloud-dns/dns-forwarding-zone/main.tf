resource "google_dns_managed_zone" "forwarding-zone" {
  for_each    = { for forwarding_zone, forwarding_zones in var.forwarding_zone_name : forwarding_zone => forwarding_zones }
  project     = each.value.project
  name        = each.value.name
  dns_name    = each.value.dns_name
  description = each.value.description


  visibility    = each.value.visibility
  force_destroy = var.force_destroy

  private_visibility_config {
    dynamic "networks" {
      for_each = each.value.network_url
      content {
        network_url = networks.value
      }
    }
  }
  forwarding_config {
    dynamic "target_name_servers" {
      for_each = each.value.ipv4_address
      content {
        ipv4_address = target_name_servers.value
      }
    }
  }
}
