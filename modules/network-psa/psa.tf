resource "google_compute_global_address" "private_ip_alloc" {
  for_each      = var.private_service_access
  project       = var.project
  network       = var.network
  name          = each.key
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = each.value.ip_address
  prefix_length = each.value.prefix
}

resource "google_service_networking_connection" "google_psa" {
  for_each                = local.private_service_access_by_service
  network                 = var.network
  service                 = each.key
  reserved_peering_ranges = [for psa_key in each.value : google_compute_global_address.private_ip_alloc[psa_key].name]
}

locals {
  services = distinct([for key, value in var.private_service_access : value.service])

  private_service_access_by_service_temp = merge([for service in local.services :
    { for key, value in var.private_service_access :
      service => key... if value.service == service
    }
  ]...)

  private_service_access_by_service = { for k, v in local.private_service_access_by_service_temp : k => distinct(v) }
}
