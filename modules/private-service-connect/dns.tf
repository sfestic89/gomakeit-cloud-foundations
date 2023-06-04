

/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/

module "googleapis" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.1"
  project_id  = var.project_id
  type        = "private"
  name        = "${local.dns_code}apis"
  domain      = "googleapis.com."
  description = "Private DNS zone to configure ${local.googleapis_url}"

  private_visibility_config_networks = [
    var.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = [local.googleapis_url]
    },
    {
      name    = local.recordsets_name
      type    = "A"
      ttl     = 300
      records = [var.private_service_connect_ip]
    },
  ]
}

/******************************************
  GCR DNS Zone & records.
 *****************************************/

module "gcr" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.1"
  project_id  = var.project_id
  type        = "private"
  name        = "${local.dns_code}gcr"
  domain      = "gcr.io."
  description = "Private DNS zone to configure gcr.io"

  private_visibility_config_networks = [
    var.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = [var.private_service_connect_ip]
    },
  ]
}

/***********************************************
  Artifact Registry DNS Zone & records.
 ***********************************************/

module "pkg_dev" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 4.1"
  project_id  = var.project_id
  type        = "private"
  name        = "${local.dns_code}pkg-dev"
  domain      = "pkg.dev."
  description = "Private DNS zone to configure pkg.dev"

  private_visibility_config_networks = [
    var.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["pkg.dev."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = [var.private_service_connect_ip]
    },
  ]
}
