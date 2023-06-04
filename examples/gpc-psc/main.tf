module "private_service_connect" {
  source                     = "../../modules/private-service-connect"
  project_id                 = var.project_id
  network_self_link          = module.simple_vpc.network_self_link
  private_service_connect_ip = "10.3.0.5"
  forwarding_rule_target     = "all-apis"
}

module "simple_vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 7.0"
  project_id   = var.project_id
  network_name = "my-custom-network"
  mtu          = 1460

  subnets = [
    {
      subnet_name           = "my-subnetwork"
      subnet_ip             = "10.0.0.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    }
  ]
}
