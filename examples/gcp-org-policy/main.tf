module "org-deafult-security-policy" {
  source = "../modules/gcp-org-policies"
  boolean_policy = [
    "appengine.disableCodeDownload",
    "bigquery.disableBQOmniAWS",
    "bigquery.disableBQOmniAzure",
    "compute.disableGuestAttributesAccess",
    "compute.disableNestedVirtualization",
    "compute.disableSerialPortAccess",
    "compute.disableVpcExternalIpv6",
    "compute.disableVpcInternalIpv6",
    "compute.requireOsLogin",
    "compute.requireShieldedVm",
    "compute.restrictXpnProjectLienRemoval",
    "compute.setNewProjectDefaultToZonalDNSOnly",
    "compute.skipDefaultNetworkCreation",
    "datastream.disablePublicConnectivity",
    "gcp.detailedAuditLoggingMode",
    "iam.automaticIamGrantsForDefaultServiceAccounts",
    "iam.disableServiceAccountKeyCreation",
    "iam.disableServiceAccountKeyUpload",
    "sql.restrictAuthorizedNetworks",
    "sql.restrictPublicIp",
    "storage.publicAccessPrevention",
    "storage.uniformBucketLevelAccess"
  ]

  list_policies = {
    policy1 = {
      constraint  = "constraints/iam.workloadIdentityPoolProviders"
      list_type   = "allow"
      list_values = ["https://gitlab.com/"]
    },
    policy2 = {
      constraint  = "constraints/gcp.resourceLocations"
      list_type   = "allow"
      list_values = ["in:eu-locations"]
    },
    policy3 = {
      constraint  = "constraints/iam.workloadIdentityPoolAwsAccounts"
      list_type   = "deny"
      list_values = ["all"]
    },
  }
}

