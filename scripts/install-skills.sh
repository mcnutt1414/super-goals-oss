#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${1:?usage: install-skills.sh <skills-dir>, e.g. ~/.claude/skills}"

mkdir -p "$SKILLS_DIR"

for skill in super-goal-plan super-goal-run; do
  src="$ROOT/skills/$skill"
  dst="$SKILLS_DIR/$skill"

  if [[ ! -f "$src/SKILL.md" ]]; then
    echo "missing source skill: $src" >&2
    exit 1
  fi

  if [[ -e "$dst" || -L "$dst" ]]; then
    if [[ -L "$dst" ]]; then
      rm "$dst"
    else
      backup="$dst.backup.$(date +%Y%m%d%H%M%S)"
      mv "$dst" "$backup"
      echo "backed up existing $dst to $backup"
    fi
  fi

  ln -s "$src" "$dst"
  echo "installed $skill -> $src"
done

echo "done: open a fresh agent session so it discovers the skills"
