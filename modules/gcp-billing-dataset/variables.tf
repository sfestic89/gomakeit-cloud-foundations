variable "billing_export_dataset_location" {
  type = string
  description = "The location of the dataset for billing data export."
}

variable "project_id" {
  type = string
}

variable "friendly_name" {
  type = string
  description = "value"
}
variable "dataset_id" {
  type = string
  default = "A unique ID for this dataset, without the project name. The ID must contain only letters (a-z, A-Z), numbers (0-9), or underscores (_). The maximum length is 1,024 characters."
}