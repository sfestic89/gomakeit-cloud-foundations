variable "display_name" {
  description = "The display name of the group."
  type        = string
}

variable "parent" {
  description = "The resource name of the entity under which this Group will be created."
  type        = string
}

variable "description" {
  description = "An extended description to help users determine the purpose of a Group."
  type        = string
  default     = ""
}

variable "group_key" {
  description = "EntityKey of the Group."
  type = object({
    id        = string
    namespace = optional(string)
  })
}

variable "labels" {
  description = "One or more label entries that apply to the Group. Currently supported labels contain a key with an empty value. Google Groups are the default type of group and have a label with a key of cloudidentity.googleapis.com/groups.discussion_forum and an empty value. Existing Google Groups can have an additional label with a key of cloudidentity.googleapis.com/groups.security and an empty value added to them. This is an immutable change and the security label cannot be removed once added. Dynamic groups have a label with a key of cloudidentity.googleapis.com/groups.dynamic. Identity-mapped groups for Cloud Search have a label with a key of system/groups/external and an empty value."
  type        = map(string)
  default     = {}
}

variable "initial_group_config" {
  description = "The initial configuration options for creating a Group. See the API reference for possible values. Default value is EMPTY. Possible values are: INITIAL_GROUP_CONFIG_UNSPECIFIED, WITH_INITIAL_OWNER, EMPTY."
  type        = string
  default     = "EMPTY"
}
