terraform {
  cloud {
    organization = "grinwis-com"
    workspaces {
      name = "akamai-property-cfm"
    }
  }

  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 3.5.0"
    }
  }
  required_version = ">= 0.13"
}

# not needed when running via Terraform cloud
/* provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
} */

data "akamai_group" "group" {
  group_name  = "Ion Standard Beta Jam 1-3-16TWBVX"
  contract_id = "ctr_3-16TWBVX"
}

data "akamai_contract" "contract" {
  group_name = data.akamai_group.group.group_name
}

# lookup all the includes as we can't use name to look them up.
data "akamai_property_includes" "my_example" {
    contract_id = data.akamai_contract.contract.id
    group_id    = data.akamai_group.group.id
}

# some chatgpt generated code to lookup the id
# the id is also in the output of the dsa-common-include workspace but just looking it up
# if var.tf_include doesn't exist lookup will fail
locals {
  dsa_common_include = split("_",lookup({
    for include in data.akamai_property_includes.my_example.includes : include.name => include.id
  }, var.tf_include, null))[1]
}


resource "akamai_edge_hostname" "incl-grinwis-com-edgesuite-net" {
  product_id    = "prd_Site_Accel"
  contract_id   = data.akamai_contract.contract.id
  group_id      = data.akamai_group.group.id
  ip_behavior   = "IPV6_COMPLIANCE"
  edge_hostname = "incl.grinwis.com.edgesuite.net"
}

resource "akamai_property" "cfm-grinwis-com" {
  name        = "cfm.grinwis.com"
  contract_id = data.akamai_contract.contract.id
  group_id    = data.akamai_group.group.id
  product_id  = "prd_Site_Accel"
  rule_format = "v2023-01-05"
  hostnames {
    cname_from             = "incl.grinwis.com"
    cname_to               = akamai_edge_hostname.incl-grinwis-com-edgesuite-net.edge_hostname
    cert_provisioning_type = "DEFAULT"
  }
  rules = data.akamai_property_rules_builder.cfm-grinwis-com_rule_default.json
}

resource "akamai_property_activation" "cfm-grinwis-com" {
  property_id = akamai_property.cfm-grinwis-com.id
  contact     = ["test@example.com"]
  version     = akamai_property.cfm-grinwis-com.latest_version
  network     = upper(var.env)
  note        = "Updated Automatically to staging."
}
