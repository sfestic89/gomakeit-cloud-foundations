variable "force_destroy" {
  description = "Disable destroying all resources whens deleting private zone"
  type        = bool
  default     = false
}

variable "public_zone_name" {
  description = "Cloud DNS Private Zone"
  type = map(object({
    project       = string
    name          = string
    dns_name      = string
    description   = string
    state         = string
    non_existence = string
    key_type      = list(string)
    key_length    = number
    algorithm     = string
  }))
}
