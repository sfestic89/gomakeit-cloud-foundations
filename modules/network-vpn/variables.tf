variable "project" {
  description = "The project name"
}
variable "vpn_name" {
  description = "The peering name"
}
variable "network" {
  description = "The network to host the VPN"
}
variable "region" {
  description = "The region of the network and VPN"
}
variable "local_gateway_bgp_asn" {
  description = "the ASN for the BGP session for the local gateway"
}
variable "peer_gateway_bgp_asn" {
  description = "the ASN for the BGP session for the remote gateway"
}
variable "external_gw_ip_1" {
  description = " IP address of the peer VPN gateway for tunnel 1"
}
variable "external_gw_ip_2" {
  description = " IP address of the peer VPN gateway for tunnel 2"
}
variable "external_gw_ip_3" {
  description = " IP address of the peer VPN gateway for tunnel 3"
}
variable "external_gw_ip_4" {
  description = " IP address of the peer VPN gateway for tunnel 4"
}
variable "sm_tunnel_1_secret" {
  description = "Key for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 1"
}
variable "sm_tunnel_1_version" {
  description = "Version for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 1"
}
variable "sm_tunnel_2_secret" {
  description = "Key for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 2"
}
variable "sm_tunnel_2_version" {
  description = "Version for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 2"
}
variable "sm_tunnel_3_secret" {
  description = "Key for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 3"
}
variable "sm_tunnel_3_version" {
  description = "Version for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 3"
}
variable "sm_tunnel_4_secret" {
  description = "Key for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 4"
}
variable "sm_tunnel_4_version" {
  description = "Version for the Secret in Secret Manager that is holding the Preshared Key for Tunnel 4"
}
variable "ike_version" {
  description = "IKE protocol version to use when establishing the VPN tunnel with peer VPN gateway. Acceptable IKE versions are 1 or 2"
}
variable "bgp_local_ip_1" {
  description = "Link-local IP address for the BGP session, Google Router IP, for tunnel 1 on interface 0 GCP, interface 0 AWS"
}
variable "bgp_peer_ip_1" {
  description = "Link-local IP address for the BGP session, AWS Router IP, for tunnel 1 on interface 0 GCP, interface 0 AWS"
}
variable "bgp_local_ip_2" {
  description = "Link-local IP address for the BGP session, Google Router IP, for tunnel 2 on interface 0 GCP, interface 1 AWS"
}
variable "bgp_peer_ip_2" {
  description = "Link-local IP address for the BGP session, AWS Router IP, for tunnel 2 on interface 0 GCP, interface 1 AWS"
}
variable "bgp_local_ip_3" {
  description = "Link-local IP address for the BGP session, Google Router IP, for tunnel 3 on interface 1 GCP, interface 2 AWS"
}
variable "bgp_peer_ip_3" {
  description = "Link-local IP address for the BGP session, AWS Router IP, for tunnel 3 on interface 1 GCP, interface 2 AWS"
}
variable "bgp_local_ip_4" {
  description = "Link-local IP address for the BGP session, Google Router IP, for tunnel 4 on interface 1 GCP, interface 3 AWS"
}
variable "bgp_peer_ip_4" {
  description = "Link-local IP address for the BGP session, AWS Router IP, for tunnel 4 on interface 1 GCP, interface 3 AWS"
}
variable "advertised_ip_ranges" {
  description = "The custom routes to export over the VPN connection"
}
