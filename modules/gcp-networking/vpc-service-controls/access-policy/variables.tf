variable "access_policies" {
  type = map(object({
    parent = string
    title  = string
    scopes = list(string)
  }))
}
