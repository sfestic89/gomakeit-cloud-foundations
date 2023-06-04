variable "project" {
  description = "the project hosting the VPC where the firewall rule will be deployed"
}
variable "network" {
  description = "the network in which to deploy the firewall rule"
}
variable "egress_allow_range" {
  description = "the allowed egress, based on target tag (sending) and destination IP (receiving)"
  type = map(object({
    description        = string
    protocols          = map(list(string))
    target_tags        = list(string)
    destination_ranges = list(string)
    priority           = optional(number)
  }))
}
variable "ingress_allow_tag" {
  description = "the allowed ingress, based on source tag (sending) and target tag (receiving)"
}
variable "ingress_allow_range" {
  description = "the allowed ingress, based on source IP range (sending) and target tag (receiving)"
}

variable "egress_deny_range" {
  type = map(object({
    description        = string
    protocols          = map(list(string))
    target_tags        = list(string)
    destination_ranges = list(string)
    priority           = optional(number)
  }))
}

variable "ingress_deny_range" {
  type = map(object({
    description   = string
    protocols     = map(list(string))
    target_tags   = list(string)
    source_ranges = list(string)
    priority      = optional(number)
  }))
}
