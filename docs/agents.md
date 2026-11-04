# Agent catalog

Engineering Toolkit has two different building blocks:

- **Skills** (`skills/<name>/SKILL.md`) are user-invoked workflows, e.g. `/code-review-agentic` or `/architecture-review-agentic` in Claude Code and `$...` in Codex. The main assistant coordinates the workflow.
- **Agents** (`agents/<name>.md`) are read-only delegated specialists used **selectively** by agentic skills. They are not automatically invoked by installing the toolkit, and are not the same thing as skills.

## Available agents

| Agent | Role | Use when | Avoid when |
| --- | --- | --- | --- |
| `code-explorer` | Low-cost navigation: locate call chains, tests, config and boundaries | A focused fact-finding question can reduce main-agent exploration | You need independent design or defect judgment |
| `language-reviewer` | General Java/Kotlin, TypeScript/JavaScript and Go implementation regressions | Changed behavior has language/framework-specific failure paths | A dedicated domain specialist better fits the main risk |
| `database-reviewer` | SQL, schemas, transaction boundaries, migrations, backfill, cutover and rollback | Data integrity, consistency or migration is central | No meaningful database behavior is involved |
| `distributed-systems-reviewer` | Messaging, Dataflow/Beam, retries, replay, idempotency and partial failures | Independent services/sinks or async events interact | A local synchronous code path is sufficient |
| `jvm-concurrency-reviewer` | JVM threads, coroutines, Spring transaction propagation and resource lifecycle | Concurrency/resource semantics determine correctness | Merely because a project uses Java or Kotlin |
| `security-reviewer` | Authentication, authorization, trust boundaries and injection | The design or diff changes a security boundary | No security-relevant behavior changes |
| `deployment-reviewer` | CI/CD, Kubernetes, rollout, rollback, observability and capacity | Deployment/runtime behavior materially affects safety | No operational/deployment implications |

Agent specifications are in `agents/`. Provider-specific adapters are in `adapters/claude/agents/` and `adapters/codex/agents/`. Each adapter is expected to match a shared specification. The adapter controls model/tool configuration; the shared spec describes behavior. Claude adapters generally use Sonnet for specialists and Haiku for code exploration; actual model availability and cost depend on your client.

## Which skill uses which agent?

| Skill | Agent selection |
| --- | --- |
| `code-review` | Baseline; no required delegation |
| `code-review-agentic` | Risk-triggered selection from specialists, at most two by default (third only for a distinct major risk) |
| `architecture-review` | Baseline; no required delegation |
| `architecture-review-agentic` | Risk-triggered selection for architecture scenarios, at most two by default |
| `jvm-concurrency-review` | Specialized skill, **not** a subagent; use directly when appropriate |
| Other skills | No automatic agentic behavior unless documented in their own `SKILL.md` |

### How routing works

1. The coordinating skill identifies the **behavioral risk**, not just file extensions or language.
2. It sends a bounded context packet and a non-overlapping question to the smallest useful set of agents.
3. Agents return candidate findings or design risks, **not final verdicts**.
4. The coordinator checks evidence, current reachability, recovery, external assumptions and fix feasibility; duplicates and speculative findings are discarded.
5. One consolidated report is returned after all delegated agents finish. When delegation is unavailable, the coordinator works directly and discloses the limitation.

**Important:** Read-only does not mean that every candidate is correct. Agent confidence labels are inputs to adjudication, not proof. Architecture review assesses design trade-offs; code review assesses actual implementation defects.

## Install

From the repository root:

```bash
bash scripts/install-skills.sh all --dry-run
bash scripts/install-skills.sh all
bash scripts/install-agents.sh all --dry-run
bash scripts/install-agents.sh all
```

The installers create symlinks without overwriting existing paths. After adding a new skill, rerun `install-skills.sh`; after adding a new agent, rerun `install-agents.sh`. Existing symlinks pick up file changes after `git pull`. Restart the client if it does not discover new entries.

Claude agent links: `~/.claude/agents`. Codex agent links: `~/.codex/agents`; some Codex versions also require explicit `[agents.<name>]` registration in `~/.codex/config.toml`. Confirm actual multi-agent support in your installed client. GitHub/GitLab MCP connectors must be configured separately.

## Example

```text
/architecture-review-agentic Mode: proposed; Scope: event ingestion; Depth: deep
/code-review-agentic Mode: changes; Target: main; Depth: deep; Comments: skip
```

For fair A/B comparisons, run the baseline and agentic variant in separate sessions against the same immutable scope. See `docs/agentic-review-benchmark.md`.
