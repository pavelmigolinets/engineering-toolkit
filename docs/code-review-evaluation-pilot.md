# Code review evaluation pilot

**Status:** Proposed protocol; no benchmark results are claimed.

## Question

Does `code-review-agentic` find additional valid defects compared with `code-review`, and are any gains worth the extra latency and cost?

## Initial cases

Prepare 3–5 small, immutable repository snapshots or commit ranges with independently verified expected issues. Include:
1. A transaction/idempotency regression with a reachable failure path.
2. A JVM concurrency or cancellation defect.
3. A cross-component partial-failure/retry defect.
4. A clean or intentionally harmless change to measure false positives.

Keep fixtures outside production repositories, avoid leaking expected findings to reviewers, and record the exact base/head SHAs. Do not treat synthetic cases as representative of all real PRs.

## Procedure

1. Run each variant in a fresh session with the same model, depth, instructions outside the skill, tools, and immutable snapshot. Disable remote comment verification for the primary comparison.
2. Collect one final report per run; preserve original findings, timing and usage metrics where available. Do not invent missing telemetry.
3. Blindly adjudicate each reported issue against code and tests: valid, invalid, or uncertain. Record missed expected defects and duplicate root causes.
4. Repeat selected cases to examine variability. Compare valid detections, false positives, critical misses, wall time, and token/dollar cost; avoid a single composite score.
5. Document confounders such as unavailable agents, different tool access, cache effects, or non-equivalent coverage.

## Result template

| Case / SHA | Variant | Expected issues found | Valid additional findings | False positives | Critical misses | Wall time | Token/cost data | Limitations |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| _not yet executed_ | — | — | — | — | — | — | — | — |

## Decision

Retain the agentic variant if it demonstrates meaningful improvement on representative defects at an acceptable cost. Otherwise simplify its routing, narrow its intended use, or keep the baseline as default. No arbitrary 100% pass gate.

This pilot complements [the existing A/B benchmark protocol](agentic-review-benchmark.md).
