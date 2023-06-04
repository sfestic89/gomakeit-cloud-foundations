variable "budget_configs" {
  type = list(object({
    billing_account_id             = string
    display_name                   = string
    disable_default_iam_recipients = optional(bool, true)
    currency_code                  = string
    amount                         = number
    threshold_percentages          = list(number)
    project_numbers                = optional(list(string), [])
    services                       = optional(list(string), [])
    notification_channel_ids       = list(string)
  }))
  description = <<EOT
    billing_account_id: ID of the billing account which the alert should observe
    display_name:
    disable_default_iam_recipients: Set to true, disables default notifications 
                                    sent when a threshold is exceeded. Default recipients are those 
                                    with Billing Account Administrators and Billing Account 
                                    Users IAM roles for the target account.
    currency_code: The 3-letter currency code defined in ISO 4217.
    amount:
    threshold_percentages: 
  EOT
  validation {
    condition = alltrue([
      for obj in var.budget_configs :
      can(regex("^ADF|ADP|AED|AFA|AFN|ALL|AMD|ANG|AOA|AOK|AON|AOR|ARA|ARL|ARP|ARS|ATS|AUD|AWG|AZM|AZN|BAD|BAM|BBD|BDT|BEF|BGL|BGN|BHD|BIF|BMD|BND|BOB|BOP|BOV|BRB|BRC|BRE|BRL|BRN|BRR|BSD|BTN|BWP|BYB|BYN|BYR|BZD|CAD|CDF|CHE|CHF|CHW|CLE|CLF|CLP|CNY|COP|COU|CRC|CSD|CSK|CUC|CUP|CVE|CYP|CZK|DDM|DEM|DJF|DKK|DOP|DZD|ECS|ECV|EEK|EGP|ERN|ESA|ESB|ESP|ETB|EUR|FIM|FJD|FKP|FRF|GBP|GEL|GHC|GHS|GIP|GMD|GNE|GNF|GQE|GRD|GTQ|GWP|HKD|HNL|HRD|HRK|HTG|HUF|IDR|IEP|ILP|ILR|ILS|INR|IQD|IRR|ISJ|ISK|ITL|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LBP|LKR|LRD|LSL|LTL|LUF|LVL|LYD|MAD|MAF|MCF|MDL|MGA|MGF|MKD|MKN|MLV|MMK|MNT|MOP|MRO|MTL|MUR|MVQ|MVR|MWK|MXN|MXP|MXV|MYR|MZM|MZN|NAD|NGN|NIO|NLG|NOK|NPR|NZD|OMR|PAB|PEN|PGK|PHP|PKR|PLN|PTE|PYG|QAR|RON|RSD|RUB|RWF|SAR|SBD|SCR|SDG|SEK|SGD|SHP|SIT|SKK|SLL|SML|SOS|SRD|SSP|STD|SVC|SYP|SZL|THB|TJS|TMT|TND|TOP|TRY|TTD|TWD|TZS|UAH|UGX|USD|USN|UYI|UYU|UZS|VAL|VEF|VND|VUV|WST|XAF|XAG|XAU|XBA|XBB|XBC|XBD|XBT|XCD|XDR|XFU|XOK|XPD|XPF|XPT|XSU|XTS|XUA|YER|ZAR|ZMW|ZWL",
      obj.currency_code)) &&
      alltrue([for p in var.budget_configs: alltrue([for t in p.threshold_percentages: 0 <= t && t <= 1.0])]) &&
      length(obj.notification_channel_ids) <= 5
    ])
    error_message = "makes sure your currency_code is valid, you don't have more than 5 notification channels per alert and your percentages are within [0,1]"
  }
}

# variable "billing_account_id" {
#   type        = string
#   description = "ID of the billing account which the alert should observe"
# }

# variable "display_name" {
#   type = string
# }

# variable "disable_default_iam_recipients" {
#   type        = bool
#   description = <<EOT
# set to true, disables default notifications 
# sent when a threshold is exceeded. Default recipients are those 
# with Billing Account Administrators and Billing Account 
# Users IAM roles for the target account.
#   EOT
#   default     = true
# }

# variable "currency_code" {
#   type        = string
#   description = "The 3-letter currency code defined in ISO 4217."
#   validation {
#     condition = can(regex("^ADF|ADP|AED|AFA|AFN|ALL|AMD|ANG|AOA|AOK|AON|AOR|ARA|ARL|ARP|ARS|ATS|AUD|AWG|AZM|AZN|BAD|BAM|BBD|BDT|BEF|BGL|BGN|BHD|BIF|BMD|BND|BOB|BOP|BOV|BRB|BRC|BRE|BRL|BRN|BRR|BSD|BTN|BWP|BYB|BYN|BYR|BZD|CAD|CDF|CHE|CHF|CHW|CLE|CLF|CLP|CNY|COP|COU|CRC|CSD|CSK|CUC|CUP|CVE|CYP|CZK|DDM|DEM|DJF|DKK|DOP|DZD|ECS|ECV|EEK|EGP|ERN|ESA|ESB|ESP|ETB|EUR|FIM|FJD|FKP|FRF|GBP|GEL|GHC|GHS|GIP|GMD|GNE|GNF|GQE|GRD|GTQ|GWP|HKD|HNL|HRD|HRK|HTG|HUF|IDR|IEP|ILP|ILR|ILS|INR|IQD|IRR|ISJ|ISK|ITL|JMD|JOD|JPY|KES|KGS|KHR|KMF|KPW|KRW|KWD|KYD|KZT|LAK|LBP|LKR|LBP|LKR|LRD|LSL|LTL|LUF|LVL|LYD|MAD|MAF|MCF|MDL|MGA|MGF|MKD|MKN|MLV|MMK|MNT|MOP|MRO|MTL|MUR|MVQ|MVR|MWK|MXN|MXP|MXV|MYR|MZM|MZN|NAD|NGN|NIO|NLG|NOK|NPR|NZD|OMR|PAB|PEN|PGK|PHP|PKR|PLN|PTE|PYG|QAR|RON|RSD|RUB|RWF|SAR|SBD|SCR|SDG|SEK|SGD|SHP|SIT|SKK|SLL|SML|SOS|SRD|SSP|STD|SVC|SYP|SZL|THB|TJS|TMT|TND|TOP|TRY|TTD|TWD|TZS|UAH|UGX|USD|USN|UYI|UYU|UZS|VAL|VEF|VND|VUV|WST|XAF|XAG|XAU|XBA|XBB|XBC|XBD|XBT|XCD|XDR|XFU|XOK|XPD|XPF|XPT|XSU|XTS|XUA|YER|ZAR|ZMW|ZWL",
#     var.currency_code))
#     error_message = "Not a 3-letter currency code defined in ISO 4217"
#   }
# }

# variable "amount" {
#   type = number
# }

# variable "threshold_percentages" {
#   type = list(number)
#   validation {
#     condition = alltrue([for p in var.threshold_percentages: 0 <= p && p <= 1.0])
#   }
# }
