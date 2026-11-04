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
for path in skills:
    text = path.read_text(encoding="utf-8")
    if not text.startswith("---\n") or "\n---\n" not in text[4:]:
        errors.append(f"{path.relative_to(ROOT)}: missing YAML frontmatter")
        continue
    header = text.split("\n---\n", 1)[0]
    if not re.search(r"(?m)^name:\s*\S+", header):
        errors.append(f"{path.relative_to(ROOT)}: missing name")
    if not re.search(r"(?m)^description:\s*\S+", header):
        errors.append(f"{path.relative_to(ROOT)}: missing description")

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
