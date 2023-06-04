output "cloud_router_ip_address" {
  value = {
    for k, v in google_compute_interconnect_attachment.interconnect_attachment : k => v.cloud_router_ip_address
  }
}

output "customer_router_ip_address" {
  value = {
    for k, v in google_compute_interconnect_attachment.interconnect_attachment : k => v.customer_router_ip_address
  }
}

output "pairing_key" {
  value = {
    for k, v in google_compute_interconnect_attachment.interconnect_attachment : k => v.pairing_key
  }
}

output "partner_asn" {
  value = {
    for k, v in google_compute_interconnect_attachment.interconnect_attachment : k => v.partner_asn
  }
}

output "private_interconnect_info" {
  value = {
    for k, v in google_compute_interconnect_attachment.interconnect_attachment : k => v.private_interconnect_info
  }
}
