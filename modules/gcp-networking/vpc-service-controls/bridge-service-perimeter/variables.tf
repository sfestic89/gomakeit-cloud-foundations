variable "bridge_perimeters" {
  description = "A map of service perimeter configurations."
  type = map(object({
    parent = string
    title  = string
    status = object({
      resources = list(any)
    })
  }))
}
