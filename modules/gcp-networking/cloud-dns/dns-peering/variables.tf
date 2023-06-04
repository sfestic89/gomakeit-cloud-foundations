variable "force_destroy" {
  description = "Disable destroying all resources whens deleting private zone"
  type        = bool
  default     = false
}

variable "peering_zone_name" {
  description = "Cloud DNS Private Zone"
  type = map(object({
    project            = string
    name               = string
    dns_name           = string
    description        = string
    visibility         = string
    network_url        = list(string)
    target_network_url = string
  }))
}
