#!/usr/bin/env bash
set -euo pipefail

test -f skill/observability-engineering/SKILL.md
test -f references/observability-model-summary.md
test -f examples/slo-intent.yaml

ruby -e 'require "yaml"; YAML.load_file("skill/observability-engineering/SKILL.md"); YAML.load_file("examples/slo-intent.yaml"); puts "yaml parses"'

grep -q '^name: observability-engineering$' skill/observability-engineering/SKILL.md
grep -q 'Use when building platform or application observability' skill/observability-engineering/SKILL.md
grep -q 'dynamic decision dashboard' skill/observability-engineering/SKILL.md
grep -q 'SRE rules are generated outputs' skill/observability-engineering/SKILL.md
grep -q 'service-onboarding-to-observability.md' skill/observability-engineering/SKILL.md
grep -q 'reliability-engineering' skill/observability-engineering/SKILL.md
grep -q 'Usage Scenario Pattern' references/observability-model-summary.md
grep -q 'Reliability Boundary' references/observability-model-summary.md

echo "validation ok"
