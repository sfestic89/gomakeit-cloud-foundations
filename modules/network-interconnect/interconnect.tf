resource "google_compute_router" "interconnect_router" {
  name    = var.router_name
  network = var.network
  region  = var.region
  project = var.project
  bgp {
    asn            = var.asn
    advertise_mode = "CUSTOM"
    dynamic "advertised_ip_ranges" {
      for_each = var.advertised_ip_ranges
      content {
        range = advertised_ip_ranges.value.range
        description = advertised_ip_ranges.value.description
      }
    }
  }
}

resource "google_compute_interconnect_attachment" "interconnect_attachment" {
  for_each = toset(var.ic_attachments_name)
  #for_each                 = toset(var.edge_availability_domain)
  name                     = each.key
  project                  = var.project
  region                   = var.region
  router                   = google_compute_router.interconnect_router.id
  edge_availability_domain = var.edge_availability_domain[index(var.ic_attachments_name, each.key)]
  type                     = "PARTNER"
  mtu                      = 1500
  admin_enabled            = var.enabled
}
