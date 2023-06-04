module "labels" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  context   = module.this.context
}
module "labels_router" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "crt-nat"
  context   = module.labels.context
}
module "labels_nat" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "nat"
  context   = module.labels.context
}

resource "google_compute_router" "router" {
  name    = module.labels_router.id
  region  = var.region
  network = var.network
  project = var.project
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project
  name                               = module.labels_nat.id
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = length(var.subnets) == 0 ? "ALL_SUBNETWORKS_ALL_IP_RANGES" : "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = var.subnets
    content {
      name                    = subnetwork.value
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
