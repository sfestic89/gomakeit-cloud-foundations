variable "boolean_policy" {
  type    = set(string)
  default = []
}

variable "list_policies" {
  description = "A map of policies to be created/updated"
  type = map(object({
    list_type   = string
    list_values = list(string)
    constraint = string
  }))
}

