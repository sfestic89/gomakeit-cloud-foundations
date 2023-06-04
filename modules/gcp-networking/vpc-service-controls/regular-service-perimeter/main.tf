provider "google" {
  alias                 = "impersonation"
  billing_project       = "terraform-project-385615"
  user_project_override = true
}

resource "google_access_context_manager_service_perimeter" "regular_service_perimeter" {
  for_each = var.service_perimeters

  provider       = google.impersonation
  parent         = each.value.parent
  name           = format("${each.value.parent}/servicePerimeters/%s", each.key)
  title          = each.value.title
  perimeter_type = "PERIMETER_TYPE_REGULAR"

  dynamic "status" {
    for_each = [each.value.status]

    content {
      restricted_services = status.value.restricted_services
      access_levels       = [status.value.access_level]
      resources = [for project_number in status.value.resources :
      "projects/${project_number}"]

      dynamic "vpc_accessible_services" {
        for_each = [status.value.vpc_accessible_services]

        content {
          enable_restriction = true
          allowed_services   = vpc_accessible_services.value.allowed_services
        }
      }

      dynamic "ingress_policies" {
        for_each = status.value.ingress_policies

        content {
          dynamic "ingress_from" {
            for_each = [ingress_policies.value.ingress_from]

            content {
              dynamic "sources" {
                for_each = [ingress_from.value.sources]

                content {
                  #resource     = status.value.resource
                  access_level = status.value.access_level
                }
              }

              identity_type = ingress_from.value.identity_type
            }
          }

          dynamic "ingress_to" {
            for_each = [ingress_policies.value.ingress_to]

            content {
              resources = ingress_to.value.resources

              dynamic "operations" {
                for_each = ingress_to.value.operations

                content {
                  service_name = operations.value.service_name

                  dynamic "method_selectors" {
                    for_each = operations.value.method_selectors

                    content {
                      #method     = method_selectors.value.method
                      permission = method_selectors.value.permission
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "egress_policies" {
        for_each = status.value.egress_policies

        content {
          dynamic "egress_from" {
            for_each = [egress_policies.value.egress_from]

            content {
              identity_type = egress_from.value.identity_type
              #identities = egress_from.value.identities
            }
          }
          dynamic "egress_to" {
            for_each = [egress_policies.value.egress_to]

            content {
              resources = egress_to.value.resources

              dynamic "operations" {
                for_each = egress_to.value.operations

                content {
                  service_name = operations.value.service_name

                  dynamic "method_selectors" {
                    for_each = operations.value.method_selectors

                    content {
                      #method     = method_selectors.value.method
                      permission = method_selectors.value.permission
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
