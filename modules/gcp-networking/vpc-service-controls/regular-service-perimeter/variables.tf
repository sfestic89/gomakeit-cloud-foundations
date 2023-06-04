variable "service_perimeters" {
  type = map(object({
    parent              = string
    title               = string
    access_level        = string
    restricted_services = list(string)
    status = object({
      restricted_services = list(string)
      access_level        = string
      resources           = list(any)
      ingress_policies = list(object({
        ingress_from = object({
          sources = list(object({
            resource     = string
            access_level = string
          }))
          identity_type = string
        })
        ingress_to = object({
          resources = list(string)
          operations = list(object({
            service_name = string
            method_selectors = list(object({
              #method     = string
              permission = string
            }))
          }))
        })
      }))
      egress_policies = list(object({
        egress_from = object({
          identity_type = string
        })
        egress_to = object({
          resources = list(string)
          operations = list(object({
            service_name = string
            method_selectors = list(object({
              #method     = string
              permission = string
            }))
          }))
        })
      }))
      vpc_accessible_services = object({
        allowed_services = list(string)
      })
    })
  }))
}
