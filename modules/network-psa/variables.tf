variable "private_service_access" {
  description = "The Private Service Accesses to configure. Needs service `servicenetworking.googleapis.com` API to be enabled in the Resource Manager"
}

variable "network" {
  description = "The VPC hosting the PSA"
}

variable "project" {
  description = "bla"
}
