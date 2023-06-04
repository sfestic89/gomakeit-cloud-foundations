variable "logging_project_id" {
  type = string
}




variable "prj_log_sink_config" {
  type = list(object({
    destination            = string
    name                   = string
    filter                 = string
    description            = optional(string)
    project_id             = string
    unique_writer_identity = optional(bool, false)
    disabled               = optional(bool, false)
    bigquery_options = optional(object({
      use_partitioned_tables = bool
    }), null)
    exclusions = optional(list(object({
      disabled    = optional(bool, false)
      name        = string
      description = optional(string, "")
      filter      = string
    })), [])
    # log_bucket_configs = object({
    #   location = string
    #   retention_days = number
    #   bucket_id = string 
    # })
    }
    )
  )

  description = <<EOT

  EOT

  default = []
}

variable "org_log_sink_config" {
  type = list(object({
    name             = string
    org_id           = string
    destination      = string
    filter           = string
    description      = optional(string)
    include_children = optional(bool, false)
    disabled         = optional(bool, false)
    bigquery_options = optional(object({
      use_partitioned_tables = bool
    }), null)
    exclusions = optional(list(object({
      disabled    = optional(bool, false)
      name        = string
      description = optional(string, "")
      filter      = string
    })), [])
    # log_bucket_configs = object({
    #   location = string
    #   retention_days = number
    #   bucket_id = string 
    # })
  }))
  default = []
}

variable "folder_log_sink_config" {
  type = list(object({
    name             = string
    folder_id        = string
    destination      = string
    filter           = string
    description      = optional(string)
    include_children = optional(bool, false)
    disabled         = optional(bool, false)
    bigquery_options = optional(object({
      use_partitioned_tables = bool
    }), null)
    exclusions = optional(list(object({
      disabled    = optional(bool, false)
      name        = string
      description = optional(string, "")
      filter      = string
    })), [])
    # log_bucket_configs = object({
    #   location = string
    #   retention_days = number
    #   bucket_id = string 
    # })
  }))
  default = []
}

variable "billing_account_log_sink_config" {
  type = list(object({
    name               = string
    billing_account_id = string
    destination        = string
    filter             = string
    description        = optional(string)
    disabled           = optional(bool, false)
    bigquery_options = optional(object({
      use_partitioned_tables = bool
    }), null)
    exclusions = optional(list(object({
      disabled    = optional(bool, false)
      name        = string
      description = optional(string, "")
      filter      = string
    })), [])
    # log_bucket_configs = object({
    #   location = string
    #   retention_days = number
    #   bucket_id = string 
    # })
  }))
  default     = []
  description = <<EOT

  You must have the "Logs Configuration Writer" IAM role (roles/logging.configWriter) granted on 
  the billing account to the credentials used with Terraform. 
  IAM roles granted on a billing account are separate from 
  the typical IAM roles granted on a project.
  EOT
}
