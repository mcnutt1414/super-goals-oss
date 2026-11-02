#!/usr/bin/env bash
# Fails if the two control-plane-contract.md copies have drifted.
# Canonical source: skills/super-goal-plan/references/control-plane-contract.md
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
A="$ROOT/skills/super-goal-plan/references/control-plane-contract.md"
B="$ROOT/skills/super-goal-run/references/control-plane-contract.md"
if diff -q "$A" "$B" >/dev/null; then
  echo "OK: control-plane-contract.md copies are in sync"
else
  echo "DRIFT: contract copies differ. Canonical is the super-goal-plan copy." >&2
  echo "Re-sync with: cp '$A' '$B'" >&2
  diff "$A" "$B" >&2 || true
  exit 1
fi
