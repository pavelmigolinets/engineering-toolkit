# Skill quality standards

These are review guidelines, not a requirement to maximize documentation or create a new framework.

## Checklist

- **Purpose and activation:** Explain when the skill should be used and when it should not.
- **Workflow:** Provide actionable steps, scope boundaries, and safe defaults.
- **Inputs and outputs:** Explain required context, expected findings/artifacts, and limitations or failure behavior.
- **Progressive disclosure:** Keep the default workflow in SKILL.md. Move optional, specialized detail into references only when it improves usability. Never enforce a token quota or percentage split.
- **Delegation:** Use specialists only when their distinct expertise justifies additional time and cost. Provide a direct fallback.
- **Evidence:** Distinguish observed facts, assumptions, and unverified claims; avoid invented tool execution.
- **Verification:** Manually exercise at least one representative scenario before publishing a substantial behavior change. Prefer repeatable evaluation cases for frequently used skills.

## What is automatically validated

Run `python3 scripts/validate-toolkit.py`. It checks frontmatter, name-to-directory consistency, nonempty instructions, explicitly named local `references/*.md` files, and existing agent adapter consistency. It is deliberately not an LLM quality judge. A successful run does **not** demonstrate that the skill is effective.

## Review and evaluation

For important skills, compare the same model and immutable input snapshot with and without the skill. Keep tools, scope, depth, and available context comparable. Track defect recall, false positives, severity, latency, and cost where observable. Adjudicate results against source/tests rather than model agreement. Start with 3–5 realistic scenarios as a pilot, expand only when the results justify it. Do not set universal pass-rate or token-count targets.

See [the code-review evaluation pilot](code-review-evaluation-pilot.md). Existing [agentic review benchmark](agentic-review-benchmark.md) remains the more detailed A/B protocol.
