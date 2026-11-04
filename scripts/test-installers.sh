#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/home"
for script in install-skills.sh install-agents.sh; do
  case "$script" in
    install-skills.sh) dest="$tmp/home/.claude/skills"; source="$root/skills/code-review"; name=code-review ;;
    install-agents.sh) dest="$tmp/home/.claude/agents"; source="$root/adapters/claude/agents/code-explorer.md"; name=code-explorer.md ;;
  esac
  mkdir -p "$dest"

  output="$(HOME="$tmp/home" bash "$root/scripts/$script" claude --dry-run)"
  grep -Fq '[NEW]' <<< "$output"
  grep -Fq 'would install=' <<< "$output"
  [[ ! -e "$dest/$name" ]]

  output="$(HOME="$tmp/home" bash "$root/scripts/$script" claude)"
  grep -Fq '[NEW]' <<< "$output"
  [[ -L "$dest/$name" ]]
  [[ "$(readlink "$dest/$name")" == "$source" ]]

  output="$(HOME="$tmp/home" bash "$root/scripts/$script" claude)"
  grep -Fq '[OK]' <<< "$output"
  grep -Fq 'already installed=' <<< "$output"

  rm "$dest/$name"
  ln -s "$tmp/other" "$dest/$name"
  output="$(HOME="$tmp/home" bash "$root/scripts/$script" claude)"
  grep -Fq '[SKIP]' <<< "$output"
  [[ "$(readlink "$dest/$name")" == "$tmp/other" ]]
  rm "$dest/$name"
done

echo 'Installer smoke tests passed.'
