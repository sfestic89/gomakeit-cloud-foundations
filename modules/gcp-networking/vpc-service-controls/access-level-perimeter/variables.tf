variable "access_levels" {
  description = "List of access levels"
  type = map(object({
    policy               = string
    name                 = string
    geographical_regions = list(string)
    ip_subnetworks       = list(string)
  }))
}
