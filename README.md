# Observability Engineering Skill

Reusable agent-agnostic skill for building platform-agnostic observability from neutral intent, including infrastructure observability readiness and telemetry pipeline intent.

Telemetry pipeline implementation workflows should use the companion `creating-observability-pipelines` skill when available. This skill remains the parent intent model for SLOs, semantic conventions, alert context, decision dashboards, and generated backend artifacts.

The skill is meant to work with the private model repo when present. The preferred checkout is the source mirror created by the workstation installer:

```text
${AGENTS_HOME:-$HOME/.agents}/vendor_imports/repos/platform-observability-model
```

It also recognizes this legacy workspace checkout:

```text
~/Library/CloudStorage/OneDrive-Personal/Pet projects/platform-observability-model
```

It can still operate from its bundled references when the private model is unavailable.

## Usage Expectations

When telemetry collection, transformation, buffering, routing, or delivery can affect SLOs, alert evidence, security, audit, cost, or backend generation, the skill should treat the telemetry pipeline as part of the observability intent. It should define source-to-sink lineage, component contracts, delivery policy, buffer policy, validation, self-observability, and generation gaps before producing backend-specific artifacts.

## Provider Terraform Adapters

Provider output stays generated from neutral intent. The skill includes a Datadog and Elastic Terraform adapter reference at `skill/observability-engineering/references/provider-terraform-adapters.md`, plus example generated files under `examples/providers/`.

Adapters must capture target, blast radius, rollback path, validation commands, and provider gaps. Secrets belong in Terraform variables or provider-supported environment variables, not generated files.

## Install With Private Model Fetch

Copy `skill/observability-engineering` into the skill directory used by your agent runtime. The install path below tries to fetch or clone the private model repo first. If the private repo is unavailable because auth or network access is missing, the skill still installs and falls back to `references/observability-model-summary.md`.

```bash
SKILLS_DIR="${SKILLS_DIR:-${AGENTS_HOME:-$HOME/.agents}/skills}"
MODEL_ROOT="${MODEL_ROOT:-${AGENTS_HOME:-$HOME/.agents}/vendor_imports/repos}"
PLATFORM_OBSERVABILITY_MODEL_REPO="${PLATFORM_OBSERVABILITY_MODEL_REPO:-git@github.com:jetteim/platform-observability-model.git}"

mkdir -p "$MODEL_ROOT"
if [ -d "$MODEL_ROOT/platform-observability-model/.git" ]; then
  if ! git -C "$MODEL_ROOT/platform-observability-model" pull --ff-only; then
    echo "private model repo update failed; bundled references remain available" >&2
  fi
else
  if ! git clone "$PLATFORM_OBSERVABILITY_MODEL_REPO" "$MODEL_ROOT/platform-observability-model"; then
    echo "private model repo clone failed; bundled references remain available" >&2
  fi
fi

mkdir -p "$SKILLS_DIR/observability-engineering"
cp -R skill/observability-engineering/. "$SKILLS_DIR/observability-engineering/"
```

## Validate

```bash
./scripts/validate.sh
```
