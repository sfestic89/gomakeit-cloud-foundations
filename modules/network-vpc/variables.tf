#TODO extend on descriptions for non-powerusers
#TODO validations
#TODO refine variable type & structure (e.g. private_service_access type=object()...)
variable "project" {
  type        = string
  description = "The project id for the VPC"
}
variable "description" {
  type        = string
  description = "The description for the VPC"
}
variable "subnets" {
  description = "The subnets for the VPC"
}
variable "routing_mode" {
  description = "The routing mode for the VPC"
}

variable "skip_default_deny_fw" {
  type = bool
  default = false
}
