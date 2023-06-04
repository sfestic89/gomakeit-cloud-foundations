module "vpc" {
  for_each             = var.vpc
  source               = "../../network-vpc"
  project              = each.value.project
  description          = each.value.description
  subnets              = each.value.subnets
  routing_mode         = each.value.routing_mode
  skip_default_deny_fw = lookup(each.value, "skip_default_deny_fw", false)


  #namespace forced by module - no need in passing as will be overwritten anyway.
  #to avoid using namespace, supply a custom label_order excluding it.
  tenant      = lookup(each.value, "tenant", null)
  environment = lookup(each.value, "environment", null)
  stage       = lookup(each.value, "stage", null)
  name        = lookup(each.value, "name", null)
  attributes  = lookup(each.value, "attributes", null)
  label_order = lookup(each.value, "label_order", null)
  context     = module.this.context

}

module "firewalls" {
  for_each            = var.firewalls
  source              = "../../network-firewall"
  project             = each.value.project
  network             = each.value.network
  egress_allow_range  = lookup(each.value, "egress_allow_range", {})
  ingress_allow_tag   = lookup(each.value, "ingress_allow_tag", {})
  ingress_allow_range = lookup(each.value, "ingress_allow_range", {})
  egress_deny_range   = lookup(each.value, "egress_deny_range", {})
  ingress_deny_range  = lookup(each.value, "ingress_deny_range", {})
  depends_on          = [module.vpc]

  #namespace forced by module - no need in passing as will be overwritten anyway.
  #to avoid using namespace, supply a custom label_order excluding it.
  tenant      = lookup(each.value, "tenant", null)
  environment = lookup(each.value, "environment", null)
  stage       = lookup(each.value, "stage", null)
  name        = lookup(each.value, "name", null)
  attributes  = lookup(each.value, "attributes", null)
  label_order = lookup(each.value, "label_order", null)
  context     = module.this.context
}
