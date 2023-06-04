module "labels_vpc" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "nw"
  context   = module.this.context
}
module "labels_default_fw" {
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "fw"
  stage     = "deny-all-egress"
  context   = module.this.context
}
module "labels_subnet" {
  for_each  = var.subnets
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "nwr"
  #context coming from VPC so is filled with VPC name - overwrite if set
  name    = lookup(each.value, "name", null)
  context = module.this.context
}

locals {

  sec_ranges_flattened = {
    for range in flatten([
      for subnet_key, subnet in var.subnets : [
        for sr_key, secondary_range in lookup(subnet, "secondary_ranges", {}) : {
          subnet_key          = subnet_key
          secondary_range_key = sr_key
          secondary_range     = secondary_range
        }
      ]
  ]) : "${range.subnet_key}-${range.secondary_range_key}" => range.secondary_range }
}

module "labels_subnet_secondaries" {
  for_each  = local.sec_ranges_flattened
  source    = "cloudposse/label/null"
  version   = "0.25.0"
  namespace = "nwr"
  name      = each.value.name
  context   = module.this.context
}

resource "google_compute_network" "vpc_network" {
  name                    = module.labels_vpc.id
  project                 = var.project
  description             = var.description
  auto_create_subnetworks = false
  ##TODO add description to vars so terraform_docs precommit generated proper documentation
  #The network-wide routing mode to use.
  # If set to REGIONAL, this network's cloud routers will only advertise routes with subnetworks of this network
  # in the same region as the router. If set to GLOBAL, this network's cloud routers will advertise routes with
  # all subnetworks of this network, across regions.
  routing_mode = var.routing_mode
  #deletes default 0.0.0.0/0 route to internet gateway - TODO add to vars
  ##TODO add description to vars so terraform_docs precommit generated proper documentation
  delete_default_routes_on_create = false
}

resource "google_compute_subnetwork" "vpc_subnet" {
  #TODO add instructions for pre-commit locally + enable on Github
  #checkov:skip=CKV_GCP_26:No VPC flow logs are needed
  for_each                 = var.subnets
  project                  = var.project
  name                     = module.labels_subnet[each.key].id
  description              = lookup(each.value, "description", null)
  network                  = google_compute_network.vpc_network.self_link
  ip_cidr_range            = each.value.cidr_primary
  region                   = each.value.region
  private_ip_google_access = lookup(each.value, "private_google_access", false)
  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ranges", {})
    content {
      ip_cidr_range = secondary_ip_range.value.cidr_range
      range_name    = module.labels_subnet_secondaries["${each.key}-${secondary_ip_range.key}"].id
    }
  }
  #TODO refactor to vars
  #TODO add description to vars so terraform_docs precommit generated proper documentation
  # log_config {
  #   aggregation_interval = "INTERVAL_10_MIN"
  #   flow_sampling        = 0.5
  #   metadata             = "INCLUDE_ALL_METADATA"
  # }
}

#explicit deny all egress to overrule the implied allow all egress.
#https://cloud.google.com/vpc/docs/firewalls#default_firewall_rules
resource "google_compute_firewall" "default" {
  count       = (var.skip_default_deny_fw == true) ? 0 : 1
  name        = module.labels_default_fw.id
  description = "default deny all egress"
  project     = var.project
  network     = google_compute_network.vpc_network.self_link
  deny {
    protocol = "all"
  }
  direction = "EGRESS"
  priority  = 65534

  #enable to get firewall logs. disabled by default for costing reasons
  #TODO move to variable
  //  log_config {
  //    metadata = "INCLUDE_ALL_METADATA" #"EXCLUDE_ALL_METADATA"
  //  }
}
