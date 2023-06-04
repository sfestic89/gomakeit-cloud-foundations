variable "vpn_configs" {
  type = map(object({
    region            = string
    network_id        = string
    project_id  = string
    peer_network_name     = string
    internal_gateways = list(object({ name = string }))
    routers = list(object({
      name    = string
      bgp_asn = number
    }))
    external_gateways = optional(list(object({
      name = string
      redundancy_type = string
      description = optional(string)
      interface_id = number
      interface_ip_addr = string
    })), [])
    tunnels = list(object({
      name                  = string
      router_name           = string
      gateway_name          = string
      external_peer         = bool
      peer_gateway_name     = string
      shared_secret         = string
      vpn_gateway_interface = number
    }))
    router_interfaces = list(object({
      name            = string
      router_name     = string
      ip_range        = string
      vpn_tunnel_name = string
    }))
    peers = list(object({
      name                      = string
      router_name               = string
      peer_ip_address           = string
      peer_asn                  = string
      advertised_route_priority = number
      interface_name            = string
    }))
  }))
}