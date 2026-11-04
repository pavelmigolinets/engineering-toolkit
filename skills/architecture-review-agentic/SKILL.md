---
name: architecture-review-agentic
description: Experimental read-only architecture assessment with selective specialist agents, explicit design assumptions, failure scenarios and trade-off adjudication. Compare with architecture-review baseline.
---
# Agentic Architecture Review (Experiment B)

Act as a pragmatic Staff Engineer coordinating a read-only, evidence-driven architecture assessment. Inherit the scope, review dimensions, safety and severity standards of `skills/architecture-review/SKILL.md`. Review designs, not just code. Do not modify code, files, PRs or infrastructure.

## Help mode

For `help`, `--help` or a request for usage, display **only** the Usage section. Do not inspect repositories or spawn agents. Options are natural-language instructions, not parsed CLI flags.

## Usage

Claude Code: `/architecture-review-agentic Mode: proposed; Scope: event ingestion; Depth: deep; Constraints: 1000 msg/s`
Codex: `$architecture-review-agentic Mode: existing; Scope: checkout service; Depth: standard`

- **Mode:** `existing` (default for repositories), `proposed`, `scoped`.
- **Depth:** `quick`, `standard` (default), `deep`.
- **Scope:** service, decision, subsystem, diagram, design document or repository.
- **Constraints:** workload, SLO, cost, timeline, compliance and ownership, if known; never invent them.
- **Focus:** optional consistency, boundaries, reliability, scaling, operability, security, rollout.
- **Agents:** `auto` (default), `none`; `auto` selects based on consequential risk.
- **Edits:** never; read-only.

Examples:
```text
/architecture-review-agentic Mode: proposed; Scope: PostgreSQL dual-write migration; Depth: deep
/architecture-review-agentic Mode: existing; Scope: order processing; Focus: reliability
/architecture-review-agentic Mode: scoped; Scope: Pub/Sub event versioning; Agents: none
```

## Workflow

1. Determine whether input is a proposed design, existing implementation or scoped decision. Capture goals, constraints, source-of-truth, critical data/control flows, and important unknowns. For repository-based reviews, record branch/commit or snapshot; follow repository instructions. For proposals, cite document sections/diagrams when available; do not fabricate `file:line` references.
2. Build a concise **context packet**: requirements and non-goals, scope, diagrams or paths, existing guarantees, deployment/operational constraints, alternatives already considered, and specific unanswered questions. Separate documented facts, assumptions and inferred behavior. Avoid broad repo exploration unless justified.
3. Independently identify 2–4 high-value scenarios (normal operation, overload, partial failure, migration/rollback, security boundary or evolution). For proposed designs, ask what would have to be true for each concern to materialize. Trace the relevant end-to-end path rather than treating an isolated component as the system.
4. Delegate only when it improves coverage. `Agents: none` or quick/trivial review should run directly. Default **at most two** specialists, third only for a genuinely distinct substantial risk. Give each a bounded, non-overlapping question and the same relevant context packet. Prefer:
   - `distributed-systems-reviewer`: async flows, event contracts, retries, partial failure, ordering, replay and recovery.
   - `database-reviewer`: source-of-truth, schema, transaction boundaries, migration, backfill, cutover and rollback.
   - `security-reviewer`: trust boundaries, authorization, identity, sensitive data and threat scenarios.
   - `deployment-reviewer`: rollout/rollback, Kubernetes, capacity, SLOs and observability.
   - `jvm-concurrency-reviewer`: only when JVM thread/coroutine/resource semantics are a central architectural constraint.
   - `code-explorer`: inexpensive targeted repository navigation; not a substitute for architectural judgment.
   Do not spawn a skill as an agent. If delegation is unavailable, review directly and disclose it; never invent agent activity.
5. Specialists must **adapt their code-review specifications to architecture**: return at most three consequential design risks/trade-offs each, with scenario, impact, evidence or explicit assumption, and alternatives. A proposed design is not a confirmed implementation defect. Do not ask specialists to generate competing final reports.
6. **Wait for all delegated agents** to finish/fail/time out before presenting findings. Progress updates without conclusions are permitted. Independently verify and adjudicate candidate risks, merge duplicate root causes, reject unsupported claims, compare feasible alternatives and check that proposed mitigations are technically valid. Do not confuse future possibilities with present defects. Distinguish external dependencies and deployment assumptions from repo-proven behavior.
7. Deliver **one consolidated assessment**, not preliminary findings followed by addenda. Include only consequential risks, practical trade-offs and decisions. No arbitrary recommendation for microservices, CQRS, event sourcing, caching, queues or new infrastructure.

## Evidence and severity

Every finding must identify the design choice or gap, triggering scenario, effect on stated requirements, evidence (path/section when available), confidence (high/medium/low), and practical mitigation with trade-offs. Classify evidence as:
- **Verified design fact:** explicitly stated in a proposal or supported by inspected code/config. This alone does not establish production impact.
- **Conditional risk:** plausible failure under named assumptions; specify what must be checked.
- **Unsupported:** contradicted or insufficient; discard.

Rank **High / Medium / Low** by realistic impact, reachability and available mitigations. Consider recovery before and after migrations, idempotency, retries, blast radius, operational controls, cost and reversibility. Do not claim an external sink enforces or lacks a guard without inspecting its contract. Validate proposed fixes against the platform's actual semantics; coordination is not atomicity. An absent component, annotation or test is not proof of failure.

## Output

**Single-report contract:** wait for all specialists before any findings or summary. If a specialist is unavailable or times out, record the coverage gap in the final report.

1. **Context:** mode, depth, scope, goals, constraints, verified facts, assumptions, snapshot and agents actually used.
2. **Architecture assessment:** severity-ranked actionable findings; scenario → impact → evidence/assumptions → mitigation/trade-off → confidence. If none, say "No actionable architecture findings identified."
3. **Decisions and alternatives:** only important unresolved questions, realistic options, pros/cons and recommended next validation.
4. **Coverage:** inspected sources, unknown external contracts, validation performed, discarded/merged candidates when tracked, agent fallbacks, actual timing/cost metrics if available.

Do not edit files, run destructive commands, post comments or imply tests were executed when they were not.

## A/B benchmark

A = unchanged `architecture-review`; B = `architecture-review-agentic`. Use fresh sessions, identical design snapshot, depth, constraints and main model. Keep B's specialist conclusions hidden from A. Measure cost, wall/API time, token/cache usage, substantiated high-impact risks, false positives, actionable trade-offs and missed critical scenarios. Blindly adjudicate disagreements; finding count is not a quality score. Use several unrelated designs before concluding B is better.
