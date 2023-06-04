resource "google_dns_managed_zone" "example-zone" {
  for_each    = { for public_zone, public_zones in var.public_zone_name : public_zone => public_zones }
  project     = each.value.project
  name        = each.value.name
  dns_name    = each.value.dns_name
  description = each.value.description

  force_destroy = var.force_destroy

  dnssec_config {
    state         = each.value.state
    non_existence = each.value.non_existence

    dynamic "default_key_specs" {
      for_each = each.value.key_type
      content {
        key_type   = default_key_specs.value
        algorithm  = each.value.algorithm
        key_length = each.value.key_length
      }
    }
  }
}
