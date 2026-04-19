#!/usr/bin/env bash
set -euo pipefail

test -f skill/observability-engineering/SKILL.md
test -f skill/observability-engineering/references/observability-model-summary.md
test -f skill/observability-engineering/references/provider-terraform-adapters.md
test -f references/observability-model-summary.md
test -f examples/slo-intent.yaml
test -f tests/scenarios/checkout-observability.prompt.md
test -f tests/scenarios/checkout-observability.expected.yaml
test -f tests/scenarios/checkout-observability.actual.yaml
test -f tests/scenarios/provider-terraform-adapters.prompt.md
test -f tests/scenarios/provider-terraform-adapters.expected.yaml
test -f tests/scenarios/provider-terraform-adapters.actual.yaml
test -f examples/providers/datadog/checkout-observability/main.tf
test -f examples/providers/elastic/checkout-observability/main.tf
test -x scripts/run-exercise.sh
test -x scripts/validate-provider-terraform.sh

ruby -e 'require "yaml"; YAML.load_file("skill/observability-engineering/SKILL.md"); YAML.load_file("examples/slo-intent.yaml"); YAML.load_file("tests/scenarios/checkout-observability.expected.yaml"); YAML.load_file("tests/scenarios/checkout-observability.actual.yaml"); YAML.load_file("tests/scenarios/provider-terraform-adapters.expected.yaml"); YAML.load_file("tests/scenarios/provider-terraform-adapters.actual.yaml"); puts "yaml parses"'
cmp -s references/observability-model-summary.md skill/observability-engineering/references/observability-model-summary.md

grep -q '^name: observability-engineering$' skill/observability-engineering/SKILL.md
grep -q 'Use when building platform or application observability' skill/observability-engineering/SKILL.md
grep -q 'dynamic decision dashboard' skill/observability-engineering/SKILL.md
grep -q 'infra-observability-readiness.md' skill/observability-engineering/SKILL.md
grep -q 'infrastructure alert context contract' skill/observability-engineering/SKILL.md
grep -q 'topology correlation' skill/observability-engineering/SKILL.md
grep -q 'telemetry pipeline health' skill/observability-engineering/SKILL.md
grep -q 'source-to-sink lineage' skill/observability-engineering/SKILL.md
grep -q 'creating-observability-pipelines' skill/observability-engineering/SKILL.md
grep -q 'Telemetry Pipeline Pattern' references/observability-model-summary.md
grep -q 'SRE rules are generated outputs' skill/observability-engineering/SKILL.md
grep -q 'service-onboarding-to-observability.md' skill/observability-engineering/SKILL.md
grep -q 'reliability-engineering' skill/observability-engineering/SKILL.md
grep -q 'vendor_imports/repos/platform-observability-model' skill/observability-engineering/SKILL.md
grep -q 'references/observability-model-summary.md' skill/observability-engineering/SKILL.md
grep -q 'PLATFORM_OBSERVABILITY_MODEL_REPO' README.md
grep -q 'vendor_imports/repos/platform-observability-model' README.md
grep -q 'Usage Scenario Pattern' references/observability-model-summary.md
grep -q 'Reliability Boundary' references/observability-model-summary.md
grep -q 'Infra Observability Readiness Pattern' references/observability-model-summary.md
grep -q 'metadata coverage' references/observability-model-summary.md
grep -q 'provider-terraform-adapters.md' skill/observability-engineering/SKILL.md
grep -q 'DataDog/datadog' examples/providers/datadog/checkout-observability/main.tf
grep -q 'datadog_service_level_objective' examples/providers/datadog/checkout-observability/main.tf
grep -q 'datadog_monitor' examples/providers/datadog/checkout-observability/main.tf
grep -q 'datadog_dashboard' examples/providers/datadog/checkout-observability/main.tf
grep -q 'datadog_service_definition_yaml' examples/providers/datadog/checkout-observability/main.tf
grep -Eq 'neutral_slo_window[[:space:]]*=[[:space:]]*"28d"' examples/providers/datadog/checkout-observability/main.tf
grep -Eq 'datadog_supported_slo_window[[:space:]]*=[[:space:]]*"30d"' examples/providers/datadog/checkout-observability/main.tf
grep -q 'Datadog create/update SLO windows do not support 28d' examples/providers/datadog/checkout-observability/main.tf
grep -q 'elastic/elasticstack' examples/providers/elastic/checkout-observability/main.tf
grep -q 'elasticstack_kibana_slo' examples/providers/elastic/checkout-observability/main.tf
grep -q 'elasticstack_kibana_action_connector' examples/providers/elastic/checkout-observability/main.tf
grep -q 'elasticstack_kibana_space' examples/providers/elastic/checkout-observability/main.tf
if command -v terraform >/dev/null 2>&1; then
  terraform fmt -check -recursive examples/providers
fi

bash -n scripts/validate-provider-terraform.sh

if [ "${OBS_VALIDATE_PROVIDER_TERRAFORM:-0}" = "1" ]; then
  ./scripts/validate-provider-terraform.sh
fi

./scripts/run-exercise.sh

echo "validation ok"
