module "vpc" {
  source    = "../basic"
  vpc       = var.vpc
  firewalls = var.firewalls
}

module "peerings" {
  for_each     = var.peerings
  source       = "../../network-peering/peering"
  network      = each.value.network
  peer_network = each.value.peer_network

  #namespace forced by module - no need in passing as will be overwritten anyway.
  #to avoid using namespace, supply a custom label_order excluding it.
  tenant      = lookup(each.value, "tenant", null)
  environment = lookup(each.value, "environment", null)
  stage       = lookup(each.value, "stage", null)
  name        = lookup(each.value, "name", null)
  attributes  = lookup(each.value, "attributes", null)
  label_order = lookup(each.value, "label_order", null)
  context     = module.this.context

  depends_on = [
    module.vpc
  ]
}
# Can be used to configure google-created peerings (e.g. when allocating PSA to GCP, Google creates underlying VPC Peering)
module "peering_config" {
  for_each             = var.peering_configs
  source               = "../../network-peering/peering-config"
  network              = each.value.network
  peering              = each.value.peering
  project              = each.value.project
  export_custom_routes = each.value.export_custom_routes
  import_custom_routes = each.value.import_custom_routes
  depends_on           = [module.psa]
}
module "xpn" {
  for_each         = var.vpc
  source           = "../../network-xpn"
  host_project     = each.value.project
  service_projects = lookup(each.value, "service_projects", [])
  depends_on = [
    module.vpc
  ]
}

module "nat" {
  for_each = var.nats
  source   = "../../network-nat"
  region   = each.value.region
  project  = each.value.project
  network  = each.value.network
  subnets  = lookup(each.value, "subnets", [])

  #namespace forced by module - no need in passing as will be overwritten anyway.
  #to avoid using namespace, supply a custom label_order excluding it.
  tenant      = lookup(each.value, "tenant", null)
  environment = lookup(each.value, "environment", null)
  stage       = lookup(each.value, "stage", null)
  name        = lookup(each.value, "name", null)
  attributes  = lookup(each.value, "attributes", null)
  label_order = lookup(each.value, "label_order", null)
  context     = module.this.context

  depends_on = [
    module.vpc
  ]
}

module "dns" {
  for_each = var.dns
  source   = "../../network-dns"
  #TODO extend with peering and forwarding zones & other features the module offers
  friendly_name = each.key
  dns_name      = each.value.dns_name
  project       = each.value.project
  records       = each.value.records
  description   = each.value.dns_description
}



module "vpn" {
  for_each              = var.vpns
  source                = "../../network-vpn"
  project               = each.value.project
  vpn_name              = each.key
  network               = each.value.network
  region                = each.value.region
  local_gateway_bgp_asn = each.value.local_gateway_bgp_asn
  peer_gateway_bgp_asn  = each.value.peer_gateway_bgp_asn
  external_gw_ip_1      = each.value.external_gw_ip_1
  external_gw_ip_2      = each.value.external_gw_ip_2
  external_gw_ip_3      = each.value.external_gw_ip_3
  external_gw_ip_4      = each.value.external_gw_ip_4
  sm_tunnel_1_secret    = each.value.sm_tunnel_1_secret
  sm_tunnel_1_version   = each.value.sm_tunnel_1_version
  sm_tunnel_2_secret    = each.value.sm_tunnel_2_secret
  sm_tunnel_2_version   = each.value.sm_tunnel_2_version
  sm_tunnel_3_secret    = each.value.sm_tunnel_3_secret
  sm_tunnel_3_version   = each.value.sm_tunnel_3_version
  sm_tunnel_4_secret    = each.value.sm_tunnel_4_secret
  sm_tunnel_4_version   = each.value.sm_tunnel_4_version
  ike_version           = each.value.ike_version
  bgp_local_ip_1        = each.value.bgp_local_ip_1
  bgp_peer_ip_1         = each.value.bgp_peer_ip_1
  bgp_local_ip_2        = each.value.bgp_local_ip_2
  bgp_peer_ip_2         = each.value.bgp_peer_ip_2
  bgp_local_ip_3        = each.value.bgp_local_ip_3
  bgp_peer_ip_3         = each.value.bgp_peer_ip_3
  bgp_local_ip_4        = each.value.bgp_local_ip_4
  bgp_peer_ip_4         = each.value.bgp_peer_ip_4
  advertised_ip_ranges  = each.value.advertised_ip_ranges
}


module "interconnect" {
  for_each                 = var.interconnects
  source                   = "../../network-interconnect"
  network                  = each.value.network
  region                   = each.value.region
  asn                      = each.value.asn
  router_name              = each.value.router_name
  ic_attachments_name      = each.value.ic_attachments_name
  edge_availability_domain = each.value.edge_availability_domain
  project                  = each.value.project
  route_priority           = each.value.route_priority
  advertised_ip_ranges     = each.value.advertised_ip_ranges
  enabled                  = each.value.enabled
  depends_on = [
    module.vpc
  ]
}

module "psa" {
  for_each               = var.vpc
  source                 = "../../network-psa"
  private_service_access = lookup(each.value, "private_service_access", {})
  network                = module.vpc.network_links[each.key]
  project                = each.value.project
}


module "routes" {
  for_each = var.routes
  source   = "../../network-routes"

  name                   = each.value.name
  project                = each.value.project
  network                = each.value.network
  description            = each.value.description
  dest_range             = each.value.dest_range
  priority               = each.value.priority
  tags                   = each.value.tags
  next_hop_gateway       = each.value.next_hop_gateway
  next_hop_instance      = each.value.next_hop_instance
  next_hop_ip            = each.value.next_hop_ip
  next_hop_vpn_tunnel    = each.value.next_hop_vpn_tunnel
  next_hop_ilb           = each.value.next_hop_ilb
  next_hop_instance_zone = each.value.next_hop_instance_zone
}
