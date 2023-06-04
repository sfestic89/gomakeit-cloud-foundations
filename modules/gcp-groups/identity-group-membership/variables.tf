variable "group" {
  description = "The name of the Group to create this membership in."
  type        = string
}

variable "preferred_member_key" {
  description = "EntityKey of the member."
  type = object({
    id        = string
    namespace = optional(string)
  })
}

variable "roles" {
  description = "The MembershipRoles that apply to the Membership. Must not contain duplicate MembershipRoles with the same name."
  type = object({
    name = string
  })
}
