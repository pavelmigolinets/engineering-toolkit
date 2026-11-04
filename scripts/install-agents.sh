#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
provider="${1:-all}"
dry_run="${2:-}"
if [[ "$provider" != "claude" && "$provider" != "codex" && "$provider" != "all" ]]; then
  echo "Usage: bash scripts/install-agents.sh [claude|codex|all] [--dry-run]" >&2
  exit 2
fi
install_for() {
  local srcdir="$1" dest="$2" source target
  for source in "$srcdir"/*; do
    [[ -f "$source" ]] || continue
    target="$dest/$(basename "$source")"
    if [[ -e "$target" || -L "$target" ]]; then
      echo "SKIP existing: $target"
    elif [[ "$dry_run" == "--dry-run" ]]; then
      echo "WOULD LINK $target -> $source"
    else
      mkdir -p "$dest"
      ln -s "$source" "$target"
      echo "LINKED $target"
    fi
  done
}
if [[ "$provider" == "claude" || "$provider" == "all" ]]; then
  install_for "$ROOT/adapters/claude/agents" "$HOME/.claude/agents"
fi
if [[ "$provider" == "codex" || "$provider" == "all" ]]; then
  install_for "$ROOT/adapters/codex/agents" "$HOME/.codex/agents"
fi
