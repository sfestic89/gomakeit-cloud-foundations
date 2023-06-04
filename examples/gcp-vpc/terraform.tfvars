vpc = {
/****************************
# Hub network and subnetworks
*****************************/
  "vpc-c-shared-base-hub" = {
    label_order          = ["name"]
    skip_default_deny_fw = true
    project              = "prj-c-base-net-hub-bc3e" # Add suffix
    description          = "Shared VPC network used for all resources within Wessling."
    routing_mode         = "GLOBAL"
    environment          = "global"
    name                 = "vpc-c-shared-base-hub"

    service_projects = [
      # Add service projects
      # "service-project-id",
    ]

    subnets = {
      "sb-c-hub-euw3-mgmt" = {
        label_order           = ["name"]
        description           = "Subnetwork for GCVE Management and Monitoring VM"
        cidr_primary          = "10.3.24.128/26"
        region                = "europe-west3"
        name                  = "sb-c-hub-euw3-mgmt" 
        private_google_access = true
        secondary_ranges      = {
          "pods" = {
            name       = "pods"
            cidr_range = "10.4.0.0/14"
          }
          "services" = {
            name       = "services"
            cidr_range = "10.5.32.0/20"
          }
        }
      }
    }
    private_service_access = {
      "psa-gcve" = {
        ip_address = "10.3.22.0"
        prefix     = "24"
        service    = "servicenetworking.googleapis.com"
      }
       "psa-backup-and-dr" = {
         ip_address = "10.3.32.0"
         prefix     = "23"
         service    = "servicenetworking.googleapis.com"
      }
       "psa-lab-process-mng" = {
         ip_address = "10.3.29.0"
         prefix     = "24"
         service    = "servicenetworking.googleapis.com"
      }
    }
  }

/*********************************************
# Spoke network and subnetworks for Production
**********************************************/
  "vpc-c-shared-spoke-prod" = {
    label_order          = ["name"]
    skip_default_deny_fw = true
    project              = "prj-c-net-spoke-prod-d5f7"
    description          = "Shared VPC network used for all resources in the production environment within Wessling Germany."
    routing_mode         = "GLOBAL"
    environment          = "global"
    name                 = "vpc-c-shared-spoke-prod"

    service_projects = [
      # Add service projects
      # "prj-de-citrix-0510"
    ]

    subnets = {
      "sb-c-spoke-euw3-prod" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling DE (Frankfurt) - Production environment"
        cidr_primary          = "10.3.0.0/22"
        region                = "europe-west3"
        name                  = "sb-c-spoke-euw3-prod" 
        private_google_access = true
      }
      "sb-c-spoke-euw9-prod" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling FR (Paris) - Production environment"
        cidr_primary          = "10.3.4.0/22"
        region                = "europe-west9"
        name                  = "sb-c-spoke-euw9-prod"
        private_google_access = true
      }
      "sb-c-spoke-euw6-prod" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling CH (Zurich) - Production environment"
        cidr_primary          = "10.3.8.0/22"
        region                = "europe-west6"
        name                  = "sb-c-spoke-euw6-prod"
        private_google_access = true
      }
      "sb-c-spoke-euc2-prod" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling PL (Warsaw) - Production environment"
        cidr_primary          = "10.3.12.0/22"
        region                = "europe-central2"
        name                  = "sb-c-spoke-euc2-prod"
        private_google_access = true
      }
    }
  }

/***************************************************************
# Spoke network and subnetworks for Development (non-production)
****************************************************************/
  "vpc-c-shared-spoke-dev" = {
    label_order          = ["name"]
    skip_default_deny_fw = true
    project              = "prj-c-net-spoke-dev-8b81"
    description          = "Shared VPC network used for all resources in the development (non-production) environment within Wessling Germany."
    routing_mode         = "GLOBAL"
    environment          = "global"
    name                 = "vpc-c-shared-spoke-dev"

    service_projects = [
      # Add service projects
    ]

    subnets = {
      "sb-c-spoke-euw3-dev" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling DE (Frankfurt) - Development (non-production) environment"
        cidr_primary          = "10.3.16.0/24"
        region                = "europe-west3"
        name                  = "sb-c-spoke-euw3-dev" 
        private_google_access = true
      }
      "sb-c-spoke-euw9-dev" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling FR (Paris) - Development (non-production) environment"
        cidr_primary          = "10.3.17.0/24"
        region                = "europe-west9"
        name                  = "sb-c-spoke-euw9-dev"
        private_google_access = true
      }
      "sb-c-spoke-euw6-dev" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling CH (Zurich) - Development (non-production) environment"
        cidr_primary          = "10.3.18.0/24"
        region                = "europe-west6"
        name                  = "sb-c-spoke-euw6-dev"
        private_google_access = true
      }
      "sb-c-spoke-euc2-dev" = {
        label_order           = ["name"]
        description           = "Subnetwork for Wessling PL (Warsaw) - Development (non-production) environment"
        cidr_primary          = "10.3.19.0/24"
        region                = "europe-central2"
        name                  = "sb-c-spoke-euc2-dev"
        private_google_access = true
      }
    }
  }
}

peering_configs = {
  "servicenetworking-googleapis-com" = {
    network              = "vpc-c-shared-base-hub"
    peering              = "servicenetworking-googleapis-com"
    project              = "prj-c-base-net-hub-bc3e"
    export_custom_routes = true
    import_custom_routes = true
  }
  "servicenetworking-googleapis-backup-and-dr" = {
    network              = "vpc-c-shared-base-hub"
    peering              = "servicenetworking-googleapis-com"
    project              = "prj-c-base-net-hub-bc3e"
    export_custom_routes = true
    import_custom_routes = true
  }
  "servicenetworking-googleapis-lab-process-mng" = {
    network              = "vpc-c-shared-base-hub"
    peering              = "servicenetworking-googleapis-com"
    project              = "prj-c-base-net-hub-bc3e"
    export_custom_routes = true
    import_custom_routes = true
  }
}

/***********************************
# VPC Peering between Hub-and-Spokes
************************************/
peerings = {
  "base-hub-to-spoke-prod" = {
    name         = "base-hub-to-spoke-prod"
    network      = "projects/prj-c-base-net-hub-bc3e/global/networks/vpc-c-shared-base-hub"
    peer_network = "projects/prj-c-net-spoke-prod-d5f7/global/networks/vpc-c-shared-spoke-prod"
  }

  "base-hub-to-spoke-dev" = {
    name         = "base-hub-to-spoke-dev"
    network      = "projects/prj-c-base-net-hub-bc3e/global/networks/vpc-c-shared-base-hub"
    peer_network = "projects/prj-c-net-spoke-dev-8b81/global/networks/vpc-c-shared-spoke-dev"
  }
}

firewalls = {
  /*******************************
# Firewalls for Hub VPC network
********************************/
  "vpc-c-shared-base-hub" = {
    label_order = ["name"]
    project     = "prj-c-base-net-hub-bc3e"
    network     = "vpc-c-shared-base-hub"
    "egress_allow_range" = {
      "fw-vpc-c-shared-base-hub-allow-all-egress" = {
        description = "Allow egress to all addresses, ports and protocols"
        protocols = {
          "all" = []
        }
        target_tags = [
        ]
        destination_ranges = [
          "0.0.0.0/0"
        ]
        priority = 65535
      }
    }
    "ingress_deny_range" = {
      "fw-vpc-c-shared-base-hub-deny-all-ingress" = {
        description = "Deny ingress from all addresses, ports and protocols"
        protocols = {
          "all" = []
        }
        target_tags = [
        ]
        source_ranges = [
          "0.0.0.0/0"
        ]
        priority = 65535
      }
    }
    "ingress_allow_range" = {
      "fw-vpc-c-shared-base-hub-allow-iap-ingress" = {
        description = "Allow ingress from IAP"
        protocols = {
          "tcp" = [22, 3389]
        }
        target_tags = [
        ]
        source_ranges = [
          "35.235.240.0/20"
        ]
        priority = 1000
      }
      "fw-vpc-c-shared-base-hub-allow-onprem-ingress" = {
        description = "Allow ingress from on-prem"
        protocols = {
          #"tcp" = [22, 3389]
          "all" = []
        }
        target_tags = [
        ]
        source_ranges = [
          "10.0.0.0/8", "192.168.0.0/16", #"172.16.0.0/16"
        ]
        priority = 1000
      }
    }
  }
/*************************************
# Firewalls for Spoke Prod VPC network
**************************************/
  "vpc-c-shared-spoke-prod" = {
    label_order = ["name"]
    project     = "prj-c-net-spoke-prod-d5f7"
    network     = "vpc-c-shared-spoke-prod"
    "egress_allow_range" = {
      "fw-vpc-c-shared-spoke-prod-allow-all-egress" = {
        description = "Allow egress to all addresses, ports and protocols"
        protocols = {
          "all" = []
        }
        target_tags = [
        ]
        destination_ranges = [
          "0.0.0.0/0"
        ]
        priority = 65535
      }
    }
    "ingress_deny_range" = {
      "fw-vpc-c-shared-spoke-prod-deny-all-ingress" = {
        description = "Deny ingress from all addresses, ports and protocols"
        protocols = {
          "all" = []
        }
        target_tags = [
        ]
        source_ranges = [
          "0.0.0.0/0"
        ]
        priority = 65535
      }
    }
    "ingress_allow_range" = {
      "fw-vpc-c-shared-spoke-prod-allow-iap-ingress" = {
        description = "Allow ingress from IAP"
        protocols = {
          "tcp" = [22, 3389]
        }
        target_tags = [
        ]
        source_ranges = [
          "35.235.240.0/20"
        ]
        priority = 1000
      }
      "fw-vpc-c-shared-spoke-prod-allow-onprem-ingress" = {
        description = "Allow ingress from on-prem"
        protocols = {
          #"tcp" = [22, 3389]
          "all" = []
        }
        target_tags = [
        ]
        source_ranges = [
          "10.0.0.0/8", "192.168.0.0/16", #"172.16.0.0/16"
        ]
        priority = 1000
      }
    }
  }
/*************************************
# Firewalls for Spoke Dev VPC network
**************************************/
  "vpc-c-shared-spoke-dev" = {
    label_order = ["name"]
    project     = "prj-c-net-spoke-dev-8b81"
    network     = "vpc-c-shared-spoke-dev"
    "egress_allow_range" = {
      "fw-vpc-c-shared-spoke-dev-allow-all-egress" = {
        description = "Allow egress to all addresses, ports and protocols"
        protocols = {
          "all" = []
        }
        target_tags = [
        ]
        destination_ranges = [
          "0.0.0.0/0"
        ]
        priority = 65535
      }
    }
    "ingress_deny_range" = {
      "fw-vpc-c-shared-spoke-dev-deny-all-ingress" = {
        description = "Deny ingress from all addresses, ports and protocols"
        protocols = {
          "all" = []
        }
        target_tags = [
        ]
        source_ranges = [
          "0.0.0.0/0"
        ]
        priority = 65535
      }
    }
    "ingress_allow_range" = {
      "fw-vpc-c-shared-spoke-dev-allow-iap-ingress" = {
        description = "Allow ingress from IAP"
        protocols = {
          "tcp" = [22, 3389]
        }
        target_tags = [
        ]
        source_ranges = [
          "35.235.240.0/20"
        ]
        priority = 1000
      }
      "fw-vpc-c-shared-spoke-dev-allow-onprem-ingress" = {
        description = "Allow ingress from on-prem"
        protocols = {
          #"tcp" = [22, 3389]
          "all" = []
        }
        target_tags = [
        ]
        source_ranges = [
          "10.0.0.0/8", "192.168.0.0/16", #"172.16.0.0/16"
        ]
        priority = 1000
      }
    }
  }
}


/*************************************
# Cloud NATs in VPC network
**************************************/
nats = {
  nat-euw3-hub = {
    label_order = ["name"]
    region      = "europe-west3"
    project     = "prj-c-base-net-hub-bc3e"
    network     = "vpc-c-shared-base-hub"
    subnets     = ["sb-c-hub-euw3-mgmt"]
    name        = "crt-nat-euw3-hub"
  }
  nat-euw3-prod = {
    label_order = ["name"]
    region      = "europe-west3"
    project     = "prj-c-net-spoke-prod-d5f7"
    network     = "vpc-c-shared-spoke-prod"
    subnets     = ["sb-c-spoke-euw3-prod"]
    name        = "crt-nat-euw3-prod"
  }
  nat-euw3-dev = {
    label_order = ["name"]
    region      = "europe-west3"
    project     = "prj-c-net-spoke-dev-8b81"
    network     = "vpc-c-shared-spoke-dev"
    subnets     = ["sb-c-spoke-euw3-dev"]
    name        = "crt-nat-euw3-dev"
  }
}

/*************************************
# Interconnects in VPC network
**************************************/
interconnects = {
  exampl-partner = {
    network                  = "projects/prj-c-base-net-hub-bc3e/global/networks/vpc-c-shared-base-hub"
    region                   = "europe-west3"
    asn                      = 16550
    router_name              = "cr-c-shared-base-hub-euw3-cr1"
    ic_attachments_name      = ["ic-altenberge-zone1-vlan1", "ic-altenberge-zone1-vlan2"]
    edge_availability_domain = ["AVAILABILITY_DOMAIN_1", "AVAILABILITY_DOMAIN_2"]
    project                  = "prj-c-base-net-hub-bc3e"
    route_priority           = 1000
    advertised_ip_ranges     = {
      "GCP-subnet-routes" = {
        range = "10.3.0.0/16"
        description = "Avertise all subnets from GCP"
      }
      "DNS-proxy-route" = {
        range = "35.199.192.0/19"
        description = "Avertise DNS proxy server route from GCP"
      }
      "Private-google-apis" = {
        range = "199.36.153.8/30"
        description = "Avertise private.googleapis.com route from GCP"
      }
    }
    #enabled                  = false
    enabled                  = true
  }

  bms-interconnect-1 = {
    network                  = "projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
    region                   = "europe-west3"
    asn                      = 16550
    router_name              = "cr-c-shared-base-hub-euw3-cr2"
    ic_attachments_name      = ["ic-bms-zone1-vlan1", "ic-bms-zone1-vlan2"]
    edge_availability_domain = ["AVAILABILITY_DOMAIN_1", "AVAILABILITY_DOMAIN_2"]
    project                  = "prj-c-base-net-hub-cf9a"
    route_priority           = 1000
    advertised_ip_ranges     = {
      # "EUW3-subnet-routes" = {
      #   range = "10.3.0.0/16"
      #   description = "Avertise all subnets from GCP"
      # }
      # "DNS-proxy-route" = {
      #   range = "35.199.192.0/19"
      #   description = "Avertise DNS proxy server route from GCP"
      # }
    }
    enabled                  = false
  }
}

vpns = {
}

/*******************************
# DNS Private and Public Zone
*******************************/
dns = {
  "private-google-apis" = {
    project                   = "prj-c-base-net-hub-cf9a"
    network                   = "projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
    dns_name                  = "googleapis.com."
    dns_description           = "Private Zone for googleapis.com"
    network_url = "https://www.googleapis.com/compute/v1/projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
    records = {
      "private.googleapis.com." = {
        type    = "A"
        ttl     = 300
        rrdatas = [
          "199.36.153.8",
          "199.36.153.9",
          "199.36.153.10",
          "199.36.153.11"
        ]
      }
      "*.googleapis.com." = {
        type    = "CNAME"
        ttl     = 300
        rrdatas = [
          "private.googleapis.com."
        ]
      }
    }
  }

  "public-dns-zone" = {
    project                   = "prj-c-base-net-hub-cf9a"
    network                   = "projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
    dns_name                  = "example.com."
    dns_description           = "Public DNS Zone for example.com"
    visibility = "public"
    network_url = "https://www.googleapis.com/compute/v1/projects/prj-c-base-net-hub-cf9a/global/networks/vpc-c-shared-base-hub"
    dnssec_config = {
      kind = "public"
      non_existence = "nsec3"
      state = "on"
    }
    records = {
      "dev.devoteam.de." = {
        type    = "A"
        ttl     = 300
        rrdatas = [
          "200.156.20.6",
        ]
      }
      "*.dev.devoteam.de." = {
        type    = "CNAME"
        ttl     = 300
        rrdatas = [
          "server-1.dev.devoteam.de."
        ]
      }
    }
  }
}

