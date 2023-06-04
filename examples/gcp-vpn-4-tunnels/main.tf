resource "google_compute_network" "network1" {
  name                    = "network1"
  routing_mode            = "GLOBAL"
  project                 = ""
  auto_create_subnetworks = false
}

resource "google_compute_network" "network2" {
  name                    = "network2"
  routing_mode            = "GLOBAL"
  project                 = ""
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network1_subnet1" {
  name          = "ha-vpn-subnet-1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "europe-west1"
  project       = ""
  network       = google_compute_network.network1.id
}

resource "google_compute_subnetwork" "network1_subnet2" {
  name          = "ha-vpn-subnet-2"
  ip_cidr_range = "10.0.2.0/24"
  region        = "europe-west3"
  project       = ""
  network       = google_compute_network.network1.id
}

resource "google_compute_subnetwork" "network2_subnet1" {
  name          = "ha-vpn-subnet-3"
  ip_cidr_range = "192.168.1.0/24"
  region        = "europe-west1"
  project       = ""
  network       = google_compute_network.network2.id
}

resource "google_compute_subnetwork" "network2_subnet2" {
  name          = "ha-vpn-subnet-4"
  ip_cidr_range = "192.168.2.0/24"
  region        = "europe-west2"
  project       = ""
  network       = google_compute_network.network2.id
}

module "vpns" {
  source = "../../modules/gcp-networking/gcp-vpn"

  vpn_configs = {
    "vpn-network-1" : {
      network_id        = google_compute_network.network1.id
      peer_network_name = "vpn-network-2"
      project_id : ""
      region            = "europe-west1"
      internal_gateways = [{ name : "ha-vpn-1" }]
      routers = [{
        name : "ha-vpn-router1"
        bgp_asn : 64514
      }]
      tunnels = [{
        name                  = "ha-vpn-tunnel1"
        gateway_name          = "ha-vpn-1"
        peer_gateway_name     = "ha-vpn-2"
        shared_secret         = "a secret message"
        router_name           = "ha-vpn-router1"
        vpn_gateway_interface = 0
        external_peer         = false
        },
        {
          name                  = "ha-vpn-tunnel2"
          gateway_name          = "ha-vpn-1"
          peer_gateway_name     = "ha-vpn-2"
          shared_secret         = "a secret message"
          router_name           = "ha-vpn-router1"
          vpn_gateway_interface = 1
          external_peer         = false
      }]
      router_interfaces = [{
        name : "router1-interface1"
        router_name : "ha-vpn-router1"
        ip_range : "169.254.0.1/30"
        vpn_tunnel_name : "ha-vpn-tunnel1"
        }, {
        name : "router1-interface2"
        router_name : "ha-vpn-router1"
        ip_range : "169.254.1.2/30"
        vpn_tunnel_name : "ha-vpn-tunnel2"
      }]
      peers = [{
        name                      = "router1-peer1"
        router_name               = "ha-vpn-router1"
        peer_ip_address           = "169.254.0.2"
        peer_asn                  = 64515
        advertised_route_priority = 100
        interface_name            = "router1-interface1"
        },
        {
          name                      = "router1-peer2"
          router_name               = "ha-vpn-router1"
          peer_ip_address           = "169.254.1.1"
          peer_asn                  = 64515
          advertised_route_priority = 100
          interface_name            = "router1-interface2"
      }]
    },
    "vpn-network-2" : {
      network_id        = google_compute_network.network2.id
      region            = "europe-west1"
      peer_network_name = "vpn-network-1"
      project_id : ""
      internal_gateways = [{ name : "ha-vpn-2" }]
      routers = [{
        name : "ha-vpn-router2"
        bgp_asn : 64515
      }]
      tunnels = [{
        name                  = "ha-vpn-tunnel3"
        gateway_name          = "ha-vpn-2"
        peer_gateway_name     = "ha-vpn-1"
        shared_secret         = "a secret message"
        router_name           = "ha-vpn-router2"
        vpn_gateway_interface = 0
        external_peer         = false
        },
        {
          name                  = "ha-vpn-tunnel4"
          gateway_name          = "ha-vpn-2"
          peer_gateway_name     = "ha-vpn-1"
          shared_secret         = "a secret message"
          router_name           = "ha-vpn-router2"
          vpn_gateway_interface = 1
          external_peer         = false
      }]
      router_interfaces = [{
        name : "router2-interface1"
        router_name : "ha-vpn-router2"
        ip_range : "169.254.0.2/30"
        vpn_tunnel_name : "ha-vpn-tunnel3"
        }, {
        name : "router2-interface2"
        router_name : "ha-vpn-router2"
        ip_range : "169.254.1.1/30"
        vpn_tunnel_name : "ha-vpn-tunnel4"
      }]
      peers = [{
        name                      = "router2-peer1"
        router_name               = "ha-vpn-router2"
        peer_ip_address           = "169.254.0.1"
        peer_asn                  = 64514
        advertised_route_priority = 100
        interface_name            = "router2-interface1"
        },
        {
          name                      = "router2-peer2"
          router_name               = "ha-vpn-router2"
          peer_ip_address           = "169.254.1.2"
          peer_asn                  = 64514
          advertised_route_priority = 100
          interface_name            = "router2-interface2"
      }]
    }
  }
}



output "inter" {
  value = module.vpns.internal_gateways_res #internal_gateways
}

# output "routers" {
#   value = module.vpns.routers
# }

output "tunnels" {
  value = module.vpns.tunnels
}

output "routers" {
  value = module.vpns.routers
}

# output "test-red" {
#   value = module.vpns.test-red
# }