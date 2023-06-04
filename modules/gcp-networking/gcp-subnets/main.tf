resource "google_compute_subnetwork" "vsf-subnets" {
  for_each      = { for subnet, subnets in var.subnets : subnet => subnets }
  name          = each.value.name
  project       = each.value.project
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = each.value.network
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
  
/******************************************************
  GCP SUBNETS WITH SECONDARY SUBNET
  ******************************************************/
 resource "google_compute_subnetwork" "vsf_gke_subnet" {
  for_each                 = { for secondary_subnet, secondary_subnets in var.secondary_subnets : secondary_subnet => secondary_subnets }
  name                     = each.value.name          #var.subnet_name
  ip_cidr_range            = each.value.ip_cidr_range #var.ip_cidr_range
  region                   = each.value.region        #var.region
  project                  = each.value.project       #var.project
  network                  = each.value.network       #var.network
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  /**
  for_each = var.vsf_secondary_subnet
  secondary_ip_range {
    range_name    = each.value.vsf_gke_subnet_pod_range_name
    ip_cidr_range = each.value.vsf_gke_subnet_pod_ip_cidr_range
  }
  secondary_ip_range {
    range_name    = each.value.vsf_gke_subnet_service_range_name
    ip_cidr_range = each.value.vsf_gke_subnet_service_ip_cidr_range
  }
**/
  dynamic "secondary_ip_range" {
    for_each = var.secondary_ip_range #each.value.secondary_ip_range
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}
/******************************************
  Create subnetwork without secondary_range
 ******************************************/
resource "google_compute_subnetwork" "basic" {
  count = var.create_secondary_ranges ? 0 : 1

  name                     = var.subnet_name
  region                   = var.region
  ip_cidr_range            = var.ip_cidr_range
  network                  = var.network
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

/******************************************
  Create subnetwork with secondary_range
 *****************************************/
resource "google_compute_subnetwork" "ranged" {
  count = var.create_secondary_ranges ? 1 : 0

  name                     = var.subnet_name
  region                   = var.region
  ip_cidr_range            = var.ip_cidr_range
  network                  = var.network
  secondary_ip_range       = "${var.secondary_ranges}"
  private_ip_google_access = true
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
