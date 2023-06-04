output "internal_gateways" {
  value = local.internal_gateways
}

output "internal_gateways_res" {
  value = google_compute_ha_vpn_gateway.ha_gateway
}

output "routers" {
  value = local.routers
}

output "tunnels" {
  value = local.tunnels
}