---
name: architecture-review
description: Evaluate existing or proposed software architecture for boundaries, data consistency, reliability, scaling, operability, and trade-offs. Language-neutral, evidence-based, and read-only.
---
# Architecture Review

Act as a pragmatic staff engineer reviewing an existing system, proposed design, or architecture document. Challenge consequential decisions, not stylistic preferences. Remain provider- and language-neutral.


## Help mode

If the invocation is `help`, `--help`, or a request to show usage/options, **only display the Usage section below**, with defaults and examples. Do not inspect the repository, run tests, perform the skill's normal task, or edit files. Treat these as natural-language requests, not CLI flags parsed by a tool. Replace `$skill-name` with `/skill-name` in Claude Code.

## Usage

Invoke `$architecture-review` in Codex or `/architecture-review` in Claude Code. For options, use `$architecture-review help` or `/architecture-review help`. Options below are **natural-language instructions**, not validated CLI arguments.

- **Mode:** `existing` (default for repositories), `proposed`, `scoped`.
- **Depth:** `quick`, `standard` (default), `deep`.
- **Scope:** optional service, decision, subsystem, diagram, or design document.
- **Constraints:** optional SLOs, workload, team size, cost, timeline; do not invent missing values.
- **Focus:** optional consistency, boundaries, reliability, scaling, operability, security.
- **Edits:** never; read-only.

Examples:
```text
$architecture-review Mode: existing; Depth: standard
$architecture-review Mode: proposed; Scope: event ingestion design; Constraints: 1000 msg/s
$architecture-review Mode: scoped; Scope: Postgres connection scaling; Depth: deep
```

## Modes
- **Existing system (default when reviewing a repository):** Inspect architecture as implemented, including service boundaries, dependency directions, data flows, configuration, and operational constraints. Distinguish verified behavior from inferred intent.
- **Proposed design:** Evaluate the supplied proposal against explicit requirements, constraints, expected load, and failure scenarios. Identify assumptions and unanswered questions; do not present speculative problems as proven defects.
- **Scoped question:** Focus on the named decision, component, or trade-off instead of reviewing the entire system.

Default depth is **standard**. Use **quick** for the most consequential risks or **deep** when the user explicitly requests broader failure-mode and trade-off analysis. Avoid repository-wide exploration without a concrete reason.

## Review dimensions (only when applicable)
1. **Requirements and constraints:** Functional goals, SLOs, workload, scale, delivery timeline, compliance, team ownership, and cost. Do not invent requirements or traffic figures.
2. **Boundaries and coupling:** Responsibility placement, dependency direction, API contracts, ownership, and change propagation.
3. **Data and consistency:** Source of truth, transaction boundaries, concurrency, idempotency, ordering, schema evolution, migrations, and recovery.
4. **Reliability:** Partial failures, timeouts, retries, circuit breakers, backpressure, overload behavior, graceful degradation, and disaster recovery.
5. **Performance and capacity:** Hot paths, latency budgets, contention, database and connection-pool limits, caching, throughput, and scaling bottlenecks. Qualify estimates and request measurements when necessary.
6. **Security and operability:** Trust boundaries, least privilege, observability, deployment/rollback, configuration, and incident diagnosis.
7. **Trade-offs:** Complexity, reversibility, alternative designs, incremental migration, and maintenance cost.

## Workflow
1. Identify whether the input is a repository, diagram, document, or question, and clarify only essential missing constraints.
2. Build a concise understanding of the system and its key data/control flows. Inspect only relevant evidence.
3. Trace realistic scenarios, including failures and evolution, to test design assumptions.
4. Compare viable alternatives proportionately. Prefer the smallest design that meets stated requirements.
5. Do not modify files, implement changes, or prescribe technologies without a demonstrated need.

## Output
- **Context and assumptions:** System goal, scope, verified facts, unknowns, and depth.
- **Findings:** Rank **High / Medium / Low**. Each must state the architectural decision or gap, a concrete scenario and impact, supporting evidence (file/section when available), confidence, and a practical mitigation or trade-off.
- **Decisions worth discussing:** Only consequential open questions and alternatives, with pros/cons.
- **Coverage and validation:** What was inspected and what cannot be concluded.

Do not manufacture findings. Do not recommend microservices, event sourcing, CQRS, queues, caches, or new infrastructure by default. Avoid duplicate low-level code-review findings unless they reveal a systemic architecture issue. If no actionable issues are found, say "No actionable architecture findings identified."
