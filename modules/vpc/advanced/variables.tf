#TODO fill with defaults in case customer does not specify
variable "vpc" {
  description = "The vpcs to be created"
}
variable "peerings" {
  description = "The peering couples"
}
variable "interconnects" {
  description = "The interconnects to create"
}
variable "firewalls" {
  description = "The firewall rules to create"
}
variable "vpns" {
  description = "The VPNs to create"
}
variable "classic_vpns" {
  type = map(object({
    project_id             = string
    vpc_network            = string
    region                 = string
    peer_ip                = string
    dest_range             = string
    psk_secret             = string
    psk_secret_version     = string
    local_traffic_selector = list(string)
  }))
  default = {}
}
variable "nats" {
  description = "The Cloud NATs to create"
}
variable "dns" {
  description = "The Cloud DNS zones to create"
}
variable "peering_configs" {}


variable "routes" {
  type = map(object({
    project                = string
    name                   = string
    network                = string
    dest_range             = string
    description            = optional(string)
    priority               = optional(number)
    tags                   = optional(list(string))
    next_hop_gateway       = optional(string)
    next_hop_instance      = optional(string)
    next_hop_ip            = optional(string)
    next_hop_vpn_tunnel    = optional(string)
    next_hop_ilb           = optional(string)
    next_hop_instance_zone = optional(string)
  }))
  default = {}
}