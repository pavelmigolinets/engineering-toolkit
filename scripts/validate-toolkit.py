#!/usr/bin/env python3
"""Read-only structural validation for Engineering Toolkit."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
errors = []

skills = sorted((ROOT / "skills").glob("*/SKILL.md"))
if not skills:
    errors.append("No skills/*/SKILL.md found")

seen_names = set()
for path in skills:
    text = path.read_text(encoding="utf-8")
    relative = path.relative_to(ROOT)
    if not text.startswith("---\n") or "\n---\n" not in text[4:]:
        errors.append(f"{relative}: missing YAML frontmatter")
        continue
    header, body = text[4:].split("\n---\n", 1)
    name_match = re.search(r"(?m)^name:\s*(\S+)\s*$", header)
    if not name_match:
        errors.append(f"{relative}: missing name")
    else:
        name = name_match.group(1)
        if name != path.parent.name:
            errors.append(f"{relative}: name '{name}' must match directory '{path.parent.name}'")
        if name in seen_names:
            errors.append(f"{relative}: duplicate skill name '{name}'")
        seen_names.add(name)
    if not re.search(r"(?m)^description:\s*\S+", header):
        errors.append(f"{relative}: missing description")
    if not body.strip():
        errors.append(f"{relative}: empty skill instructions")

    # Only validate explicitly named local reference files, not arbitrary
    # examples, URLs, or paths to other repositories.
    for ref in set(re.findall(r"(?<![\w/])references/([\w./-]+\.md)\b", body)):
        target = (path.parent / "references" / ref).resolve()
        references_dir = (path.parent / "references").resolve()
        if not target.is_relative_to(references_dir) or not target.is_file():
            errors.append(f"{relative}: missing local reference references/{ref}")

agents = sorted((ROOT / "agents").glob("*.md"))
for agent in agents:
    name = agent.stem
    for adapter in (ROOT / "adapters/claude/agents" / f"{name}.md",
                    ROOT / "adapters/codex/agents" / f"{name}.toml"):
        if not adapter.is_file():
            errors.append(f"{name}: missing {adapter.relative_to(ROOT)}")

for adapter_dir, extension in (("adapters/claude/agents", ".md"), ("adapters/codex/agents", ".toml")):
    for adapter in (ROOT / adapter_dir).glob(f"*{extension}"):
        if not (ROOT / "agents" / f"{adapter.stem}.md").is_file():
            errors.append(f"{adapter.relative_to(ROOT)}: no shared agent specification")

if errors:
    print("\n".join(f"ERROR: {error}" for error in errors), file=sys.stderr)
    sys.exit(1)
print(f"Validated {len(skills)} skills and {len(agents)} agents.")
