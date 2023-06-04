variable "region" {
  type        = string
  description = "The region for the NAT"
}

variable "network" {
  type        = string
  description = "The VPC for the NAT"
}

variable "project" {
  type        = string
  description = "The project for the NAT"
}

variable "subnets" {
  type        = list(any)
  description = "Use empty array to map all subnets to the NAT. Fill array with specific subnets to only NAT those subnets"
  default     = []
}
