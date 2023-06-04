variable "projects" {
  type = map(object({
    name            = string
    project_id      = string
    billing_account = string
  }))
}

variable "org_id" {
  type    = string
  default = ""
}

variable "folder_id" {
  type    = string
  default = ""
}

variable "labels" {
  type = map(string)
  default = {}
  description = "(Optional) A set of key/value label pairs to assign to the project."  
}

variable "auto_create_network" {
  type = bool
  default = false
}