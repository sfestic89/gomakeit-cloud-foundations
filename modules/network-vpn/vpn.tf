resource "google_compute_ha_vpn_gateway" "gcp-vpn-gw" {
  name    = format("gw-%s", var.vpn_name)
  network = var.network
  region  = var.region
  project = var.project
}

// 1 external, 4 tunnels elk op deze GW. 4 interfaces op deze 1 GW.
resource "google_compute_external_vpn_gateway" "external_gateway" {
  name            = format("egw-%s", var.vpn_name)
  project         = var.project
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  description     = "The external gateway at AWS for HA SLA covered VPN setup"
  interface {
    id         = 0
    ip_address = var.external_gw_ip_1
  }
  interface {
    id         = 1
    ip_address = var.external_gw_ip_2
  }
  interface {
    id         = 2
    ip_address = var.external_gw_ip_3
  }
  interface {
    id         = 3
    ip_address = var.external_gw_ip_4
  }
}

/*
data "google_secret_manager_secret_version" "psk-tunnel-1" {
  secret  = var.sm_tunnel_1_secret
  version = var.sm_tunnel_1_version
  project = var.project
}

data "google_secret_manager_secret_version" "psk-tunnel-2" {
  secret  = var.sm_tunnel_2_secret
  version = var.sm_tunnel_2_version
  project = var.project
}

data "google_secret_manager_secret_version" "psk-tunnel-3" {
  secret  = var.sm_tunnel_3_secret
  version = var.sm_tunnel_3_version
  project = var.project
}

data "google_secret_manager_secret_version" "psk-tunnel-4" {
  secret  = var.sm_tunnel_4_secret
  version = var.sm_tunnel_4_version
  project = var.project
}
*/

resource "google_compute_vpn_tunnel" "tunnel-1" {
  name                            = format("%s-tunnel-1", var.vpn_name)
  project                         = var.project
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-vpn-gw.name
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.name
  peer_external_gateway_interface = 0
  shared_secret                   = data.google_secret_manager_secret_version.psk-tunnel-1.secret_data
  ike_version                     = var.ike_version
  router                          = google_compute_router.gcp-router.name
}

resource "google_compute_vpn_tunnel" "tunnel-2" {
  name                            = format("%s-tunnel-2", var.vpn_name)
  project                         = var.project
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-vpn-gw.name
  vpn_gateway_interface           = 0
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.name
  peer_external_gateway_interface = 1
  shared_secret                   = data.google_secret_manager_secret_version.psk-tunnel-2.secret_data
  ike_version                     = var.ike_version
  router                          = google_compute_router.gcp-router.name
}

resource "google_compute_vpn_tunnel" "tunnel-3" {
  name                            = format("%s-tunnel-3", var.vpn_name)
  project                         = var.project
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-vpn-gw.name
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.name
  peer_external_gateway_interface = 2
  shared_secret                   = data.google_secret_manager_secret_version.psk-tunnel-3.secret_data
  ike_version                     = var.ike_version
  router                          = google_compute_router.gcp-router.name
}

resource "google_compute_vpn_tunnel" "tunnel-4" {
  name                            = format("%s-tunnel-4", var.vpn_name)
  project                         = var.project
  region                          = var.region
  vpn_gateway                     = google_compute_ha_vpn_gateway.gcp-vpn-gw.name
  vpn_gateway_interface           = 1
  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.name
  peer_external_gateway_interface = 3
  shared_secret                   = data.google_secret_manager_secret_version.psk-tunnel-4.secret_data
  ike_version                     = var.ike_version
  router                          = google_compute_router.gcp-router.name
}

resource "google_compute_router" "gcp-router" {
  name    = format("crt-%s", var.vpn_name)
  region  = var.region
  network = var.network
  project = var.project
  bgp {
    asn            = var.local_gateway_bgp_asn
    advertise_mode = "CUSTOM"
    dynamic "advertised_ip_ranges" {
      for_each = var.advertised_ip_ranges
      content {
        range = advertised_ip_ranges.value
      }
    }
  }
}

//creates a BGP interface on the router for each tunnel
resource "google_compute_router_interface" "router-interface-0-tunnel-1" {
  name       = format("crti-%s-1", var.vpn_name)
  router     = google_compute_router.gcp-router.name
  region     = var.region
  project    = var.project
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-1.name
  ip_range   = var.bgp_local_ip_1
}

resource "google_compute_router_interface" "router-interface-0-tunnel-2" {
  name       = format("crti-%s-2", var.vpn_name)
  router     = google_compute_router.gcp-router.name
  region     = var.region
  project    = var.project
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-2.name
  ip_range   = var.bgp_local_ip_2
}

resource "google_compute_router_interface" "router-interface-1-tunnel-3" {
  name       = format("crti-%s-3", var.vpn_name)
  router     = google_compute_router.gcp-router.name
  region     = var.region
  project    = var.project
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-3.name
  ip_range   = var.bgp_local_ip_3
}

resource "google_compute_router_interface" "router-interface-1-tunnel-4" {
  name       = format("crti-%s-4", var.vpn_name)
  router     = google_compute_router.gcp-router.name
  region     = var.region
  project    = var.project
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-4.name
  ip_range   = var.bgp_local_ip_4
}

//connect each router interface to the peered side
resource "google_compute_router_peer" "router-peer-tunnel-1" {
  name                      = format("crtp-%s-1", var.vpn_name)
  router                    = google_compute_router.gcp-router.name
  region                    = var.region
  project                   = var.project
  peer_ip_address           = var.bgp_peer_ip_1
  peer_asn                  = var.peer_gateway_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router-interface-0-tunnel-1.name
}

resource "google_compute_router_peer" "router-peer-tunnel-2" {
  name                      = format("crtp-%s-2", var.vpn_name)
  router                    = google_compute_router.gcp-router.name
  region                    = var.region
  project                   = var.project
  peer_ip_address           = var.bgp_peer_ip_2
  peer_asn                  = var.peer_gateway_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router-interface-0-tunnel-2.name
}

resource "google_compute_router_peer" "router-peer-tunnel-3" {
  name                      = format("crtp-%s-3", var.vpn_name)
  router                    = google_compute_router.gcp-router.name
  region                    = var.region
  project                   = var.project
  peer_ip_address           = var.bgp_peer_ip_3
  peer_asn                  = var.peer_gateway_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router-interface-1-tunnel-3.name
}

resource "google_compute_router_peer" "router-peer-tunnel-4" {
  name                      = format("crtp-%s-4", var.vpn_name)
  router                    = google_compute_router.gcp-router.name
  region                    = var.region
  project                   = var.project
  peer_ip_address           = var.bgp_peer_ip_4
  peer_asn                  = var.peer_gateway_bgp_asn
  advertised_route_priority = 100
  interface                 = google_compute_router_interface.router-interface-1-tunnel-4.name
}
