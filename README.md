# Observability Engineering Skill

Reusable agent-agnostic skill for building platform-agnostic observability from neutral intent.

The skill is meant to work with a local model repo when present:

```text
~/Library/CloudStorage/OneDrive-Personal/Pet projects/platform-observability-model
```

It can still operate from its bundled references when the private model is unavailable.

## Install

Copy `skill/observability-engineering` into the skill directory used by your agent runtime. For a portable shell install, set `SKILLS_DIR` first:

```bash
mkdir -p "$SKILLS_DIR/observability-engineering"
cp -R skill/observability-engineering/. "$SKILLS_DIR/observability-engineering/"
```

## Validate

```bash
./scripts/validate.sh
```
