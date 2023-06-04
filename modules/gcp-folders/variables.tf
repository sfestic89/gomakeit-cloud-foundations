variable "folders" {
  type = map(object({
    display_name = string
    parent       = string
  }))
}
