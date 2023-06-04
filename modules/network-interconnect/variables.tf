variable "network" {
  description = "The FQDN of the vpc to deploy the resources in"
}
variable "region" {
  description = "the region of the router of the interconnect attachment"
}
variable "asn" {
  description = "the ASN for the BGP router"
}
variable "router_name" {
  description = "the name used for the router"
}
variable "ic_attachments_name" {
  description = "the names used for the interconnect attachments"
}
variable "edge_availability_domain" {
  description = "the metro area used for the interconnect attachment"
}
variable "route_priority" {
  description = "the route priority"
}
variable "project" {
  description = "the Google Cloud project that will host the interconnect"
}
variable "advertised_ip_ranges" {
  description = "The IP ranges on GCP to advertise on the BGP router to go over the interconnect"
}
variable "enabled" {
  type        = bool
  description = "enable/disable the attachment"
}
