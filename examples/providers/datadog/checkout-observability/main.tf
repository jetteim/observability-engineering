terraform {
  required_version = ">= 1.5.0"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 4.4.0, < 5.0.0"
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

variable "notify_targets" {
  type    = list(string)
  default = []
}

variable "runbook_url" {
  type    = string
  default = "https://runbooks.example.invalid/checkout-api"
}

provider "datadog" {}

locals {
  source_intent                 = "ObservabilityIntent/SloIntent/AlertContextContract/DecisionDashboardPlan"
  neutral_slo_window            = "28d"
  datadog_supported_slo_window  = "30d"
  datadog_supported_slo_windows = ["7d", "30d", "90d"]
  provider_generation_gaps      = ["Datadog create/update SLO windows do not support 28d; generated Terraform uses 30d and requires review before apply."]
  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "owner:${var.owner}",
    "source_intent:checkout-observability",
    "managed_by:terraform",
  ]
  monitor_message = join("\n", concat([
    "Checkout reliability signal for ${var.service_name}.",
    "Source intent: ${local.source_intent}.",
    "Runbook: ${var.runbook_url}",
  ], var.notify_targets))
}

resource "datadog_service_level_objective" "checkout_success_ratio" {
  name        = "${var.service_name} checkout success ratio"
  type        = "metric"
  description = "Generated from neutral SloIntent. Good events are paid orders; total events are checkout attempts."

  query {
    numerator   = "sum:checkout.paid_orders{service:${var.service_name},env:${var.environment}}.as_count()"
    denominator = "sum:checkout.attempts{service:${var.service_name},env:${var.environment}}.as_count()"
  }

  thresholds {
    timeframe = local.datadog_supported_slo_window
    target    = 99.5
    warning   = 99.7
  }

  tags = local.tags
}

resource "datadog_monitor" "checkout_error_budget_burn_rate" {
  name    = "${var.service_name} checkout error budget burn rate"
  type    = "query alert"
  message = local.monitor_message
  query   = "avg(last_15m):avg:checkout.error_budget_burn_rate{service:${var.service_name},env:${var.environment}} > 2"

  monitor_thresholds {
    critical = 2
    warning  = 1
  }

  include_tags        = true
  require_full_window = false
  tags                = local.tags
}

resource "datadog_service_definition_yaml" "checkout_api" {
  service_definition = <<-YAML
schema-version: v2.2
dd-service: ${var.service_name}
team: ${var.owner}
contacts:
  - name: Checkout Team
    type: email
    contact: checkout-team@example.invalid
description: Generated from neutral ObservabilityIntent for checkout reliability ownership.
tier: high
lifecycle: ${var.environment}
type: web
links:
  - name: Checkout runbook
    type: runbook
    url: ${var.runbook_url}
tags:
  - service:${var.service_name}
  - env:${var.environment}
  - owner:${var.owner}
  - source-intent:checkout-observability
extensions:
  reliability.intent/source:
    slo-window: ${local.neutral_slo_window}
    provider-window: ${local.datadog_supported_slo_window}
YAML
}

resource "datadog_dashboard" "checkout_reliability_decision" {
  title       = "${var.service_name} reliability decision dashboard"
  description = "Generated from neutral DecisionDashboardPlan for incident response and release readiness."
  layout_type = "ordered"

  widget {
    timeseries_definition {
      title = "Checkout attempts and paid orders"
      request {
        q            = "sum:checkout.attempts{service:${var.service_name},env:${var.environment}}.as_count()"
        display_type = "line"
      }
      request {
        q            = "sum:checkout.paid_orders{service:${var.service_name},env:${var.environment}}.as_count()"
        display_type = "line"
      }
    }
  }

  widget {
    timeseries_definition {
      title = "Error budget burn rate"
      request {
        q            = "avg:checkout.error_budget_burn_rate{service:${var.service_name},env:${var.environment}}"
        display_type = "line"
      }
    }
  }
}

output "provider_generation_gaps" {
  value = local.provider_generation_gaps
}
