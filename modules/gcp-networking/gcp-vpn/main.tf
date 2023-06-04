locals {
  internal_gateways = { for x in flatten([for key, value in var.vpn_configs : [for gateway in value.internal_gateways : { "${key}_${gateway.name}" = {
    name : gateway.name
    region : value.region
    network_id : value.network_id
    project: value.project_id
  } }]]) : keys(x)[0] => values(x)[0] }

  routers = { for x in flatten([for key, value in var.vpn_configs : [for router in value.routers : { "${key}_${router.name}" = {
    name : router.name
    region : value.region
    bgp_asn : router.bgp_asn
    network_id : value.network_id
    project: value.project_id
  } }]]) : keys(x)[0] => values(x)[0] }

  tunnels = { for x in flatten([for key, value in var.vpn_configs : [for tunnel in value.tunnels : { "${key}_${tunnel.name}" = {
    name : tunnel.name
    region : value.region
    network_id : value.network_id
    project: value.project_id
    key : key
    gateway_name          = tunnel.gateway_name
    router_name           = tunnel.router_name
    external_peer         = tunnel.external_peer
    peer_network_name     = value.peer_network_name
    peer_gateway_name     = tunnel.peer_gateway_name
    shared_secret         = tunnel.shared_secret
    vpn_gateway_interface = tunnel.vpn_gateway_interface
  } }]]) : keys(x)[0] => values(x)[0] }

  router_interfaces = { for x in flatten([for key, value in var.vpn_configs : [for interface in value.router_interfaces : { "${key}_${interface.name}" = {
    name : interface.name
    region : value.region
    key : key
    router_name           = interface.router_name
    project: value.project_id
    ip_range   = interface.ip_range
    vpn_tunnel = interface.vpn_tunnel_name
  } }]]) : keys(x)[0] => values(x)[0] }

  peers = { for x in flatten([for key, value in var.vpn_configs : [for peer in value.peers : { "${key}_${peer.name}" = {
    name : peer.name
    region : value.region
    project: value.project_id
    key : key
    router_name           = peer.router_name
    peer_ip_address: peer.peer_ip_address
    peer_asn: peer.peer_asn
    advertised_route_priority = peer.advertised_route_priority
    interface_name = peer.interface_name
  } }]]) : keys(x)[0] => values(x)[0] }

  ext_gw = { for x in flatten([for key, value in var.vpn_configs : [for gw in value.external_gateways : { "${key}_${gw.name}" = {
    project: value.project_id
    key : key
    name = gw.name
    redundancy_type = gw.redundancy_type
    description = gw.description == null ? "" : gw.description
    interface_id = gw.interface_id
    interface_ip_addr = gw.interface_ip_addr
  } }]]) : keys(x)[0] => values(x)[0] }
}

resource "google_compute_ha_vpn_gateway" "ha_gateway" {
  for_each = local.internal_gateways
  project = each.value.project
  region   = each.value.region
  name     = each.value.name
  network  = each.value.network_id
}

resource "google_compute_router" "routers" {
  for_each = local.routers
  name     = each.value.name
  project = each.value.project
  region = each.value.region
  network  = each.value.network_id
  bgp {
    asn = each.value.bgp_asn
  }
}

resource "google_compute_vpn_tunnel" "tunnel" {
  for_each              = local.tunnels
  name                  = each.value.name
  region                = each.value.region
  vpn_gateway           = google_compute_ha_vpn_gateway.ha_gateway["${each.value.key}_${each.value.gateway_name}"].id

  peer_gcp_gateway      = google_compute_ha_vpn_gateway.ha_gateway["${each.value.peer_network_name}_${each.value.peer_gateway_name}"].id
  shared_secret         = each.value.shared_secret
  router                = google_compute_router.routers["${each.value.key}_${each.value.router_name}"].id
  vpn_gateway_interface = each.value.vpn_gateway_interface
  project = each.value.project
}

resource "google_compute_router_interface" "routers_interfaces" {
  for_each   = local.router_interfaces
  name       = each.value.name
  router     = google_compute_router.routers["${each.value.key}_${each.value.router_name}"].name
  region     = each.value.region
  ip_range   = each.value.ip_range
  vpn_tunnel = google_compute_vpn_tunnel.tunnel["${each.value.key}_${each.value.vpn_tunnel}"].name
  project = each.value.project
}

resource "google_compute_router_peer" "peers" {
  for_each = local.peers
  name                      = each.value.name
  router                    = google_compute_router.routers["${each.value.key}_${each.value.router_name}"].name
  region                    = each.value.region
  peer_ip_address           = each.value.peer_ip_address
  peer_asn                  = each.value.peer_asn
  advertised_route_priority = each.value.advertised_route_priority
  interface                 = google_compute_router_interface.routers_interfaces["${each.value.key}_${each.value.interface_name}"].name
  project = each.value.project
}

resource "google_compute_external_vpn_gateway" "external_gateway" {
  for_each = try(local.ext_gw, {})
  name            = each.value.name
  redundancy_type = each.value.redundancy_type
  description     = each.value.description
  interface {
    id         = each.value.interface_id
    ip_address = each.value.name.ip_address
  }
}
