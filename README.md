# Engineering Toolkit

Reusable engineering skills, specialist agents, prompts, and project guidance for Codex and Claude Code.

## What's included

- **Reviews:** `code-review` and experimental `code-review-agentic` (A/B variant)
- **Architecture:** `architecture-review` and `architecture-review-agentic`
- **JVM:** `jvm-concurrency-review` for Java/Kotlin concurrency
- **Tests:** `test-review` (read-only) and `test-writing` (focused test changes)
- **Specialist agents:** code exploration, database, language, distributed systems, JVM concurrency, security, and deployment
- **Templates:** general, Go, TypeScript/JavaScript, and React/Next.js `AGENTS.md`
- **Prompts:** code review, independent review, and review adjudication

Read the [agent catalog](docs/agents.md) and [A/B benchmark protocol](docs/agentic-review-benchmark.md) for routing and comparisons.

## Install

From the repository root:

```bash
bash scripts/install-skills.sh all --dry-run
bash scripts/install-skills.sh all
bash scripts/install-agents.sh all --dry-run
bash scripts/install-agents.sh all
```

| Provider | Skills | Agents |
| --- | --- | --- |
| Codex | `~/.agents/skills` | `~/.codex/agents` |
| Claude Code | `~/.claude/skills` | `~/.claude/agents` |

Installers do not overwrite existing paths. When changing checkouts, inspect and remove old symlinks first, then rerun these scripts. Some Codex versions also require agent registration in `~/.codex/config.toml`; see [agent catalog](docs/agents.md).

## Choose the right skill

| Task | Skill |
| --- | --- |
| Find actionable implementation defects | `code-review` |
| Try bounded specialist delegation | `code-review-agentic` |
| Review system design and production risks | `architecture-review` |
| Try specialist-assisted architecture review | `architecture-review-agentic` |
| Investigate Java/Kotlin concurrency | `jvm-concurrency-review` |
| Assess tests without editing | `test-review` |
| Add focused tests and regressions | `test-writing` |

Invoke with `$code-review` in Codex or `/code-review` in Claude Code. Ask `$code-review help` or `/code-review help` for documented natural-language options.

The agentic variants select only relevant specialists and fall back to direct review when delegation is unavailable.

## Reviewing pull requests

`code-review-agentic` supports local diffs and read-only GitHub PR / GitLab MR reviews, when the agent runtime has its own connector configured. It can check whether existing review feedback was addressed without posting comments or altering review status.

For a blind second opinion, use [Independent review](prompts/independent-review.md) in a fresh session against an immutable commit; then use [Review adjudication](prompts/review-adjudication.md) to verify differing findings.

## Validate

```bash
python3 scripts/validate-toolkit.py
```

GitHub Actions runs the same structural validation.

## Scope

Reusable engineering workflows and tooling. Shared agent specifications live under `agents/`; provider-specific configuration lives under `adapters/`. Review skills are read-only unless otherwise documented.
