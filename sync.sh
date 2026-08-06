#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/.croc/agents/yandex360-ops/obsidian-notes"
cd "$REPO_DIR"

if [[ -z "$(git status --porcelain)" ]]; then
  exit 0
fi

git add -A
git commit -m "auto: sync $(date -u +'%Y-%m-%d %H:%M') UTC"
git push origin main
