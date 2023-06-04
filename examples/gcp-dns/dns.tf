resource "google_dns_policy" "default_policy" {
  project                   = "prj-c-base-net-hub-cf9a"
  name                      = "dp-dns-hub-default-policy"
  enable_inbound_forwarding = true
  enable_logging            = true
  networks {
    network_url = "https://www.googleapis.com/compute/v1/projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
  }
}

module "dns-forwarding-zone" {
  source     = "../modules/gcp-networking/cloud-dns/dns-forwarding-zone"
  forwarding_zone_name = {
    forwarding_zone_onprem = {
      project    = "prj-c-base-net-hub-cf9a"
      name       = "dp-dns-hub-default-forwarding"
      dns_name   = "de.devoteam.de."
      description = "Forwarding zone for on-prem"
      visibility = "private"
      network_url = [
        "https://www.googleapis.com/compute/v1/projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
      ]
      target_name_servers = {
        server-1 = {
          ipv4_address    = "8.8.8.8",
          forwarding_path = "default"
      },
        server-2 = {
          ipv4_address    = "8.8.4.4",
          forwarding_path = "default"
      }
      }
    }
  }
}


module "dns-peering-zone" {
  source     = "../modules/gcp-networking/cloud-dns/dns-peering"
  peering_zone_name = {
    peering_zone_spoke = {
      project    = "prj-c-base-net-hub-cf9a"
      name       = "dp-dns-hub-peering"
      dns_name   = "de.devoteam.de."
      description = "Peering zone for spoke"
      visibility = "private"
      network_url = [
        "https://www.googleapis.com/compute/v1/projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
      ]
      target_network_url = "https://www.googleapis.com/compute/v1/projects/prj-c-net-spoke-dev-c117/global/networks/vpc-c-shared-spoke-dev"
    }
  }
}