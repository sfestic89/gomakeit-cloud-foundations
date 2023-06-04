variable "vpc" {
  description = "The vpcs to be created"
  default     = {}
}

variable "peerings" {
  description = "The peering couples"
  default     = {}
}

variable "interconnects" {
  description = "The interconnects to create"
  default     = {}
}

variable "firewalls" {
  description = "The firewall rules to create"
  default     = {}
}

variable "vpns" {
  description = "The VPNs to create"
  default     = {}
}

variable "nats" {
  description = "The Cloud NATs to create"
  default     = {}
}

variable "dns" {
  description = "The Cloud DNS zones to create"
  default     = {}
}

variable "peering_configs" {
  description = "Custom configs on peerings like export/import custom ranges"
  default     = {}
}
