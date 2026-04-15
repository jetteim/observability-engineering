#!/usr/bin/env bash
set -euo pipefail

test -f skill/observability-engineering/SKILL.md
test -f skill/observability-engineering/references/observability-model-summary.md
test -f references/observability-model-summary.md
test -f examples/slo-intent.yaml

ruby -e 'require "yaml"; YAML.load_file("skill/observability-engineering/SKILL.md"); YAML.load_file("examples/slo-intent.yaml"); puts "yaml parses"'
cmp -s references/observability-model-summary.md skill/observability-engineering/references/observability-model-summary.md

grep -q '^name: observability-engineering$' skill/observability-engineering/SKILL.md
grep -q 'Use when building platform or application observability' skill/observability-engineering/SKILL.md
grep -q 'dynamic decision dashboard' skill/observability-engineering/SKILL.md
grep -q 'infra-observability-readiness.md' skill/observability-engineering/SKILL.md
grep -q 'infrastructure alert context contract' skill/observability-engineering/SKILL.md
grep -q 'topology correlation' skill/observability-engineering/SKILL.md
grep -q 'telemetry pipeline health' skill/observability-engineering/SKILL.md
grep -q 'source-to-sink lineage' skill/observability-engineering/SKILL.md
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

echo "validation ok"
