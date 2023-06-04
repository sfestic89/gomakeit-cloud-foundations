provider "google" {

}

module "advanced" {
  source          = "../modules/vpc/advanced"
  vpc             = var.vpc
  firewalls       = var.firewalls
  peerings        = var.peerings
  nats            = var.nats
  dns             = var.dns
  vpns            = var.vpns
  interconnects   = var.interconnects
  peering_configs = var.peering_configs
}
