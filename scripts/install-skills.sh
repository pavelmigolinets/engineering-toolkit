#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash scripts/install-skills.sh [codex|claude|all] [--dry-run]

Install shared skills as symlinks:
  codex  -> ~/.agents/skills
  claude -> ~/.claude/skills
  all    -> both (default)

Existing files and symlinks pointing elsewhere are never overwritten.
EOF
}

provider=all
dry_run=false
for arg in "$@"; do
  case "$arg" in
    codex|claude|all) provider="$arg" ;;
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source_dir="$root/skills"
installed=0
existing=0
skipped=0

install_for() {
  local destination="$1" source name target current
  for source in "$source_dir"/*; do
    [[ -d "$source" && -f "$source/SKILL.md" ]] || continue
    name="${source##*/}"
    target="$destination/$name"
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
  codex) install_for "$HOME/.agents/skills" ;;
  claude) install_for "$HOME/.claude/skills" ;;
  all)
    install_for "$HOME/.agents/skills"
    install_for "$HOME/.claude/skills"
    ;;
esac
if [[ "$dry_run" == true ]]; then
  printf 'Dry-run summary: would install=%d, already installed=%d, skipped=%d\n' "$installed" "$existing" "$skipped"
else
  printf 'Installation summary: installed=%d, already installed=%d, skipped=%d\n' "$installed" "$existing" "$skipped"
fi
