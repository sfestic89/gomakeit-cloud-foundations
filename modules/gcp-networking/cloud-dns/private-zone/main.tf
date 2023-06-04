resource "google_dns_managed_zone" "private_zone" {
  for_each    = { for private_zone, private_zones in var.private_zone_name : private_zone => private_zones }
  project     = each.value.project
  name        = each.value.name
  dns_name    = each.value.dns_name
  description = each.value.description


  visibility    = each.value.visibility
  force_destroy = var.force_destroy

  private_visibility_config {
    dynamic "networks" {
      for_each    = each.value.network_url
      content {
      network_url = networks.value
      }
    }
  }
}
