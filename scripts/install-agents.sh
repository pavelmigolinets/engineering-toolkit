#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash scripts/install-agents.sh [claude|codex|all] [--dry-run]

Install provider-specific specialist agents as symlinks:
  claude -> ~/.claude/agents
  codex  -> ~/.codex/agents
  all    -> both (default)

Existing files and symlinks pointing elsewhere are never overwritten.
EOF
}

provider=all
dry_run=false
for arg in "$@"; do
  case "$arg" in
    claude|codex|all) provider="$arg" ;;
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
installed=0
existing=0
skipped=0

install_for() {
  local source_dir="$1" destination="$2" source target current
  for source in "$source_dir"/*; do
    [[ -f "$source" ]] || continue
    target="$destination/${source##*/}"
    if [[ -L "$target" ]]; then
      current="$(readlink "$target")"
      if [[ "$current" == "$source" ]]; then
        printf '[OK]   %s -> %s\n' "$target" "$source"
        ((existing+=1))
      else
        printf '[SKIP] %s (symlink points to %s)\n' "$target" "$current"
        ((skipped+=1))
      fi
    elif [[ -e "$target" ]]; then
      printf '[SKIP] %s (existing path)\n' "$target"
      ((skipped+=1))
    elif [[ "$dry_run" == true ]]; then
      printf '[NEW]  %s -> %s (dry run)\n' "$target" "$source"
      ((installed+=1))
    else
      mkdir -p "$destination"
      ln -s "$source" "$target"
      printf '[NEW]  %s -> %s\n' "$target" "$source"
      ((installed+=1))
    fi
  done
}

case "$provider" in
  claude) install_for "$root/adapters/claude/agents" "$HOME/.claude/agents" ;;
  codex) install_for "$root/adapters/codex/agents" "$HOME/.codex/agents" ;;
  all)
    install_for "$root/adapters/claude/agents" "$HOME/.claude/agents"
    install_for "$root/adapters/codex/agents" "$HOME/.codex/agents"
    ;;
esac
if [[ "$dry_run" == true ]]; then
  printf 'Dry-run summary: would install=%d, already installed=%d, skipped=%d\n' "$installed" "$existing" "$skipped"
else
  printf 'Installation summary: installed=%d, already installed=%d, skipped=%d\n' "$installed" "$existing" "$skipped"
fi
