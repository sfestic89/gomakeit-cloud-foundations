variable "vpc" {
  description = "Cloud DNS Private Zone"
  type = map(object({
    project                 = string
    name                    = string
    auto_create_subnetworks = string
    description             = string
    routing_mode            = string
  }))
}
