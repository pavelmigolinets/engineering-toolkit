#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./scripts/install-skills.sh [codex|claude|all] [--dry-run]

Install shared skills as symbolic links in your user-level agent directories.
  codex  -> ~/.agents/skills
  claude -> ~/.claude/skills
  all    -> both (default)

Existing real files/directories or links to another target are never overwritten.
Update the toolkit with git pull; linked skills update automatically.
EOF
}

provider="all"
dry_run=false
for arg in "$@"; do
  case "$arg" in
    codex|claude|all) provider="$arg" ;;
    --dry-run) dry_run=true ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown argument: %s\n' "$arg" >&2; usage >&2; exit 2 ;;
  esac
done

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
skills_dir="$(cd -- "$script_dir/../skills" && pwd -P)"

install_for() {
  local destination="$1" skill source target
  if [[ "$dry_run" == false ]]; then
    mkdir -p -- "$destination"
  fi
  for source in "$skills_dir"/*; do
    [[ -d "$source" && -f "$source/SKILL.md" ]] || continue
    skill="${source##*/}"
    target="$destination/$skill"
    if [[ -L "$target" ]]; then
      if [[ "$(readlink -- "$target")" == "$source" ]]; then
        printf 'Already installed: %s\n' "$target"
      else
        printf 'SKIP (existing symlink): %s\n' "$target" >&2
      fi
    elif [[ -e "$target" ]]; then
      printf 'SKIP (existing path): %s\n' "$target" >&2
    elif [[ "$dry_run" == true ]]; then
      printf 'Would link: %s -> %s\n' "$target" "$source"
    else
      ln -s -- "$source" "$target"
      printf 'Installed: %s -> %s\n' "$target" "$source"
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
