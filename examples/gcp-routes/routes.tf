module "google_compute_route" {
  source       = "../modules/network-routes"
  project      = "prj-c-base-net-hub-cf9a" # Replace this with your project ID in quotes
  network_name = "projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      dest_range        = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}