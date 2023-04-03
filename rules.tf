
data "akamai_property_rules_builder" "cfm-grinwis-com_rule_default" {
  rules_v2023_01_05 {
    name      = "default"
    is_secure = false
    comments  = "The Default Rule template contains all the necessary and recommended features. Rules are evaluated from top to bottom and the last matching rule wins."
    behavior {
      origin {
        cache_key_hostname            = "REQUEST_HOST_HEADER"
        compress                      = true
        enable_true_client_ip         = true
        forward_host_header           = "ORIGIN_HOSTNAME"
        hostname                      = "nc3566.deta.dev"
        http_port                     = 80
        https_port                    = 443
        origin_certificate            = ""
        origin_sni                    = true
        origin_type                   = "CUSTOMER"
        ports                         = ""
        true_client_ip_client_setting = false
        true_client_ip_header         = "True-Client-IP"
        verification_mode             = "PLATFORM_SETTINGS"
      }
    }
    behavior {
      http2 {
        enabled = ""
      }
    }
    behavior {
      allow_transfer_encoding {
        enabled = true
      }
    }
    behavior {
      http3 {
        enable = true
      }
    }
    behavior {
      http_strict_transport_security {
        enable               = true
        include_sub_domains  = true
        max_age              = "ONE_DAY"
        preload              = true
        redirect             = true
        redirect_status_code = 301
      }
    }
    children = [
      data.akamai_property_rules_builder.cfm-grinwis-com_rule_new_rule.json,
      data.akamai_property_rules_builder.cfm-grinwis-com_rule_augmented_insights.json,
    ]
  }
}

data "akamai_property_rules_builder" "cfm-grinwis-com_rule_new_rule" {
  rules_v2023_01_05 {
    name                  = "New Rule"
    is_secure             = false
    criteria_must_satisfy = "all"
    behavior {
      include {
        id = local.dsa_common_include
      }
    }
  }
}

data "akamai_property_rules_builder" "cfm-grinwis-com_rule_augmented_insights" {
  rules_v2023_01_05 {
    name                  = "Augmented Insights"
    is_secure             = false
    criteria_must_satisfy = "all"
    behavior {
      cp_code {
        value {
          created_date = 1541508578000
          description  = "jgrinwis"
          id           = 789214
          name         = "jgrinwis"
          products     = ["Fresca", ]
        }
      }
    }
    behavior {
      datastream {
        log_enabled         = true
        log_stream_name     = 28708
        log_stream_title    = ""
        sampling_percentage = 100
        stream_type         = "LOG"
      }
    }
  }
}
