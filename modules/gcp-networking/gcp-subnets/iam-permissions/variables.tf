variable "subnet_iam_permissions" {
  description = "Map of project IDs to a map of subnet names to a map of role names and members"
  type        = map(map(map(object({
    members = list(string)
    region  = string
  }))))
  default     = {}
}
