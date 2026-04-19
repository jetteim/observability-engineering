#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
terraform_bin="${TERRAFORM_BIN:-terraform}"

if ! command -v "$terraform_bin" >/dev/null 2>&1; then
  echo "terraform binary not found: $terraform_bin" >&2
  exit 1
fi

workdir="$(mktemp -d "${TMPDIR:-/tmp}/observability-provider-terraform.XXXXXX")"
trap 'rm -rf "$workdir"' EXIT

for provider in datadog elastic; do
  source_dir="$repo_root/examples/providers/$provider/checkout-observability"
  target_dir="$workdir/$provider"
  mkdir -p "$target_dir"
  cp "$source_dir/main.tf" "$target_dir/main.tf"

  (
    cd "$target_dir"
    "$terraform_bin" init -backend=false -input=false
    "$terraform_bin" validate
  )
done

echo "provider terraform validation ok"
