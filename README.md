# Engineering Toolkit

Reusable, provider-neutral engineering prompts, skills, specialist agents, and templates for Codex and Claude Code.

The toolkit helps with code review, architecture analysis, JVM concurrency, testing, independent review, and agent-assisted workflows. Skills provide reusable workflows; agents are selectively delegated specialists; templates provide per-project instructions.

## Shared agent skills

Skills live in `skills/<skill-name>/SKILL.md`. Both Codex and Claude Code can use the same skills through user-level symlinks.

From the repository root:

```bash
bash scripts/install-skills.sh all --dry-run
bash scripts/install-skills.sh all
```

Or install for one provider:

```bash
bash scripts/install-skills.sh codex
bash scripts/install-skills.sh claude
```

Skill installation locations:

- Codex: `~/.agents/skills/<skill-name>`
- Claude Code: `~/.claude/skills/<skill-name>`

The installer never overwrites existing paths. It works with a checkout anywhere on disk and creates absolute symlinks to the checked-out skills. After `git pull`, linked content updates automatically; rerun the installer to link newly added skills. Restart your agent session if newly installed skills are not discovered.

If you previously installed this toolkit from another checkout, **inspect and update old symlinks** before reinstalling. The installer deliberately skips existing links pointing elsewhere.

Use `$code-review` in Codex or `/code-review` in Claude Code to invoke the shared review skill.

## Available skills

| Skill | Focus |
| --- | --- |
| `code-review` | General code review with quick, standard, and deep modes |
| `code-review-agentic` | Experimental specialist-assisted code review, optional Markdown reports, and existing PR/MR feedback verification |
| `test-review` | Read-only test effectiveness, missing scenarios, and flakiness |
| `test-writing` | Write focused automated tests and regressions using existing conventions |
| `jvm-concurrency-review` | Java/Kotlin concurrency and runtime correctness |
| `architecture-review` | System boundaries, reliability, data consistency, scalability, and trade-offs |
| `architecture-review-agentic` | Experimental specialist-assisted architecture assessment |
| `independent-review` | Blind second opinion in a fresh session |
| `review-adjudication` | Verify existing findings and recheck fixes |
| `independent-review` | Blind second opinion in a fresh session, without previous findings |
| `review-adjudication` | Verify existing findings, compare reviews, and recheck fixes |

Example invocations: `$test-review` in Codex, `/test-review` in Claude Code. After pulling new skills, rerun `bash scripts/install-skills.sh all` to link them into both agents.

### Skill help and options

Each skill documents its supported **natural-language** options, defaults, and examples in its own `SKILL.md`. Ask for help without running the skill's normal task:

```text
$code-review help
$test-writing help
$architecture-review help
$code-review-agentic help
$independent-review help
$review-adjudication help
$independent-review help
$review-adjudication help
```

For Claude Code, use `/code-review help`, `/test-writing help`, etc. The same pattern applies to **all installed skills**. `help` and `--help` are instructions to the agent, **not** a formally validated command-line interface.

You can always read `skills/<skill-name>/SKILL.md` directly and consult its **Usage** section.

### Choosing the right skill

Use **one skill matching the immediate task**, rather than running every review skill in sequence:

| You want to… | Use |
| --- | --- |
| Find actionable implementation defects | `code-review` |
| Independently assess complex changes with targeted specialists | `code-review-agentic` |
| Obtain a blind second opinion in a fresh session | `independent-review` |
| Verify existing findings or whether fixes addressed them | `review-adjudication` |
| Obtain a blind second opinion in a fresh session | `independent-review` |
| Check whether review findings are valid or fixed | `review-adjudication` |
| Identify missing tests, weak assertions, or flaky tests without editing | `test-review` |
| Add focused tests or reproduce a bug with a regression test | `test-writing` |
| Investigate Java/Kotlin races, cancellation, or thread-pool behavior | `jvm-concurrency-review` |
| Challenge service boundaries, data flows, scaling, or architectural trade-offs | `architecture-review` |
| Assess complex architecture with selective independent specialists | `architecture-review-agentic` |

Review skills are **read-only**; `test-writing` changes tests and fixtures only by default. Use a targeted follow-up skill when the initial review identifies a specific gap.

## Independent multi-agent reviews

For a second opinion on the **same commit or immutable code snapshot**, use [independent-review](prompts/independent-review.md) in a fresh agent conversation **without sharing the first review's findings**.

After both reviews finish, use [review-adjudication](prompts/review-adjudication.md) to verify disagreements against source and tests. Different model opinions are evidence to investigate, not votes.

The corresponding `independent-review` and `review-adjudication` **skills** are installed by the skill installer. The linked prompts remain reusable as plain Markdown instructions when working in an environment without skill discovery.

## Reusable agent instruction templates

- [General engineering AGENTS.md](templates/AGENTS.md): focused edits, evidence, tests, safety, and conflicting repository guidance.
- [Go AGENTS.md](templates/go/AGENTS.md): idiomatic Go, contexts, errors, concurrency, and test boundaries.
- [TypeScript/JavaScript AGENTS.md](templates/typescript/AGENTS.md): runtime validation, async behavior, typing, and testing.
- [React/Next.js AGENTS.md](templates/react-nextjs/AGENTS.md): components, hooks, server/client boundaries, accessibility, and testing.

Copy and adapt the applicable template into your project. These templates are **not installed globally**, should not contain credentials, and should not blindly override existing `AGENTS.md` or `CLAUDE.md` instructions.

## Experimental agentic code review (A/B)

The `code-review` skill is the baseline (A), while `code-review-agentic` is experimental variant B. The agentic variant supports local diffs and **read-only** GitHub PR/GitLab MR reviews, including checking whether existing reviewer comments were addressed. It never posts comments or changes review state.

Install both skills and provider-specific agent adapters:

```bash
bash scripts/install-skills.sh all --dry-run
bash scripts/install-skills.sh all
bash scripts/install-agents.sh all --dry-run
bash scripts/install-agents.sh all
```

Claude agent adapters are linked under `~/.claude/agents`. Codex agent TOML adapters are linked under `~/.codex/agents`. Depending on your Codex version, you may also need to register them in `~/.codex/config.toml`:

```toml
[agents.code-explorer]
description = "Targeted read-only code exploration"
config_file = "agents/code-explorer.toml"

[agents.language-reviewer]
description = "Independent language-specific code review"
config_file = "agents/language-reviewer.toml"
```

Check your installed Codex version's multi-agent support before use. The agentic skill must fall back to a direct review if delegation is unavailable.

Example invocations:

```text
/code-review-agentic Mode: changes; Target: main; Depth: deep
$code-review-agentic https://github.com/owner/repo/pull/123; Comments: verify
```

GitHub/GitLab MCP connectors must be configured **separately in the local agent runtime**; this repository does not install or authenticate them. Existing comments are read-only inputs. A resolved thread alone is not evidence that its concern is fixed, and the independent reviewer is kept blind to prior comments.

See the [A/B benchmark protocol](docs/agentic-review-benchmark.md). Compare both variants in fresh sessions against the **same immutable commit range** and measure verified review quality, cost, time, and token usage.

### Saving a review report for verification

Agentic code review prints its consolidated findings in chat by default. To preserve a Markdown report for a separate verification session:

```text
$code-review-agentic Mode: changes; Target: main; Depth: deep; Output: both; Report: .reviews/code-review.md
```

`Output: chat` (default) writes nothing; `Output: markdown` saves the final report; `Output: both` displays and saves it. The report is written **only when requested** and never overwrites an existing file without permission.

Open a fresh session and verify the findings:

```text
$review-adjudication Findings: .reviews/code-review.md; Mode: verify; Snapshot: HEAD
```

For a genuinely blind second opinion, use `$independent-review` in a **fresh session without providing the saved report**. Only use `review-adjudication` after you want the agent to inspect the previous findings.

### Optional Markdown reports and finding verification

By default, `code-review-agentic` writes no files. To save its **final consolidated report** for verification in a new session:

```text
$code-review-agentic Mode: changes; Target: main; Depth: deep; Output: both; Report: .reviews/code-review.md
```

`Output: chat` (default) writes nothing; `Output: markdown` saves the report; `Output: both` saves and displays it. Existing files are never overwritten without approval.

To challenge the saved findings in a fresh session:

```text
$review-adjudication Findings: .reviews/code-review.md; Mode: verify; Snapshot: HEAD
```

For a genuinely blind second opinion, use `$independent-review` in a **fresh session without providing the previous report**. Use `review-adjudication` when you intentionally want to evaluate prior findings.

## Agent catalog and architecture reviews

See the [Agent catalog](docs/agents.md) for available delegated agents, responsibilities, selection triggers, provider adapters, and installation guidance.

The baseline `architecture-review` works without required delegation. The experimental `architecture-review-agentic` selectively delegates to relevant specialists (two by default) and independently adjudicates risks and trade-offs into one report.

Example:

```text
/architecture-review-agentic Mode: proposed; Scope: event ingestion; Depth: deep
```

The equivalent Codex invocation begins with `$architecture-review-agentic`. Compare both versions against the same design snapshot before assuming the agentic variant is better.

## Validation

Run the structural validator from the repository root:

```bash
python3 scripts/validate-toolkit.py
```

The GitHub Actions workflow runs the same check to validate skill frontmatter and agent/adapters consistency.
