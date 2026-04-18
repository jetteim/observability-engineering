terraform {
  required_version = ">= 1.5.0"

  required_providers {
    elasticstack = {
      source  = "elastic/elasticstack"
      version = ">= 0.14.2, < 1.0.0"
    }
  }
}

variable "service_name" {
  type    = string
  default = "checkout-api"
}

variable "environment" {
  type    = string
  default = "production"
}

variable "owner" {
  type    = string
  default = "checkout-team"
}

variable "logs_data_view" {
  type    = string
  default = "logs-checkout-*"
}

provider "elasticstack" {
  elasticsearch {}
  kibana {}
}

locals {
  source_intent = "ObservabilityIntent/SloIntent/AlertContextContract/DecisionDashboardPlan"
  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "owner:${var.owner}",
    "source_intent:checkout-observability",
    "managed_by:terraform",
  ]
  provider_generation_gaps = [
    "Dashboard generation may require Kibana saved object export/import or API validation for the target version.",
    "Alert rule generation requires validating the exact Kibana rule_type_id parameter schema before apply.",
  ]
}

resource "elasticstack_kibana_space" "checkout" {
  space_id    = "checkout-observability"
  name        = "Checkout Observability"
  description = "Generated workspace for ${var.service_name} reliability evidence."
  initials    = "CO"
}

resource "elasticstack_kibana_slo" "checkout_success_ratio" {
  name             = "${var.service_name} checkout success ratio"
  description      = "Generated from neutral SloIntent. Good events are paid orders; total events are checkout attempts."
  space_id         = elasticstack_kibana_space.checkout.space_id
  budgeting_method = "occurrences"
  tags             = local.tags

  kql_custom_indicator {
    index           = var.logs_data_view
    good            = "event.action: \"order.paid\" and service.name: \"${var.service_name}\" and deployment.environment: \"${var.environment}\""
    total           = "event.action: \"checkout.attempt\" and service.name: \"${var.service_name}\" and deployment.environment: \"${var.environment}\""
    timestamp_field = "@timestamp"
  }

  time_window {
    duration = "28d"
    type     = "rolling"
  }

  objective {
    target = 0.995
  }

  settings {
    sync_delay = "5m"
    frequency  = "5m"
  }
}

resource "elasticstack_kibana_action_connector" "reliability_evidence_index" {
  name              = "${var.service_name} reliability evidence index"
  connector_type_id = ".index"
  space_id          = elasticstack_kibana_space.checkout.space_id

  config = jsonencode({
    index   = "checkout-reliability-evidence"
    refresh = true
  })
}

output "provider_generation_gaps" {
  value = local.provider_generation_gaps
}
