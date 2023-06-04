variable "host_project" {
  type        = string
  description = "The host project"
}
variable "service_projects" {
  type        = list(string)
  description = "The service project"
}
