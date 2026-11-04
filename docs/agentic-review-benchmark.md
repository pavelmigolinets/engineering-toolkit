# Agentic review A/B benchmark

Compare the unchanged `code-review` skill (A) with `code-review-agentic` (B).

1. Select at least three immutable diff ranges: small, medium, and complex. Record repository, base SHA, head SHA and review depth.
2. Run A and B in separate fresh sessions with the same main model and settings. Alternate order between trials to limit warm-cache/order bias. Avoid sharing review findings between runs.
3. For the primary comparison set `Comments: skip` in B. Test comment verification separately so B does not do extra work.
4. Capture session totals: dollar cost, wall/API duration, input/output tokens, cache reads/writes, model breakdown, number of subagents and tool calls where available.
5. Independently verify findings against code and tests; count true positives, false positives, high/critical misses and duplicates.
6. Compare cost and duration alongside review quality. Target >=20% cost reduction without losing high/critical findings; this is an experimental target, not a guarantee.

| Diff SHA | Variant | Cost USD | Wall seconds | API seconds | Input | Output | Cache read | Cache write | Valid | False positive | High/critical missed |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| | A | | | | | | | | | | |
| | B | | | | | | | | | | |

Remote review verification: provide PR/MR URL and `Comments: verify`. Provider MCP must be configured in the running client; this toolkit does not install GitHub/GitLab MCP servers. No posting comments, approvals, thread resolutions or code edits.

## Trial 1 — Kotlin/Apache Beam dual-write MR (historical baseline)

Repository: external MR checkout; base `977cb51b`, head `6e1d87b`; deep review, ~76 changed files. Historical Opus run is contextual, **not** a controlled Sonnet A/B comparison.

| Variant | Main model | Cost USD | Wall | API | Output tokens | Cache read | Cache write | Reported findings |
| --- | --- | ---: | --- | --- | ---: | ---: | ---: | ---: |
| Historical | Opus | 4.72 | 15m 12s | 8m 56s | 41.4k | 4.5m | 222.9k | 4 |
| A: code-review | Sonnet 4.6 | 2.86 | 15m 51s | 9m 7s | 30.9k | 6.7m | 102.5k | 5 |
| B: code-review-agentic (v1) | Sonnet 4.6 | 2.38 | 9m 13s | 15m 24s | 51.3k | 2.0m | 253.6k | 9 |

B used two language-reviewer agents (database/transaction scope and Dataflow/JVM scope). A/B observed cost reduction: 16.8%; wall reduction: 41.8%. API duration increased and cache state differed; one trial cannot establish repeatability. Reported finding count is not a quality score.

### Independent adjudication case H1
B raised a High-risk issue: two independent Apache Beam JDBC sinks write old/new tables from changes computed **only against the old table**. If old commits but new fails, later reruns can see no delta against old and suppress repair of new. A focused, separate Opus investigation corroborated the directional recovery asymmetry by tracing the Beam graph, sink transaction boundaries and delta source. This is a **strongly corroborated code-path finding**, not a demonstrated production incident. Verify actual failure/retry behavior and operational reconciliation before claiming production impact. Neither historical Opus nor A identified H1.

Other B findings included latent transaction annotations, duplicate DELETE risk, missing test coverage, duplicate mappers and performance hypotheses. Several are not current reachable defects and should not be counted as validated bugs. This motivates stricter coordinator adjudication.

### Trial B2 — specialist routing (same frozen diff)
Sonnet 4.6; cost $3.39; wall 13m 42s; API 24m 54s; 83.6k output, 3.0m cache read, 311.4k cache write; eight reported findings. Specialists: distributed-systems-reviewer and database-reviewer. B2 cost 42.4% more than B1, wall 48.6% longer. Cache conditions differ, so results are exploratory.

**Adjudication updates:**
- H1: independent Beam sinks can diverge during the short dual-write window, but the claim of *permanent* drift is conditional. Once the delta baseline switches to the new table, a complete successful re-evaluation can repair stale entries. Production exposure depends on cutover ordering and deletion/reconciliation handling. Classify as migration sequencing risk until cutover contract is verified.
- Draft/Active Stanley contamination: B2 discovered a shared Draft/Active Pub/Sub topic and Stanley entity key. A separate focused Sonnet investigation traced Draft triggers, differing rule sets, subscription configuration and unconditional consumer forwarding. The repository strongly supports a potential cross-environment overwrite; actual Stanley write-side guards and live GCP overrides remain external assumptions. Treat as high-priority investigation, not fully proven downstream corruption.
- Missing @Transactional: current callers reportedly provide transactions, so future-only partial deletion is not a current Medium defect.
- V47 invalid CREATE INDEX CONCURRENTLY: PostgreSQL can leave an INVALID index and IF NOT EXISTS can skip it, but the suggested DO-block DROP INDEX CONCURRENTLY remediation is **invalid**; use separate nontransactional repair/runbook steps.
- Side-input identity performance and duplicate DELETE idempotency are unverified low-value risks, not substantiated current defects.

**Next benchmark:** Compare quality-gated agentic review against the same immutable diff without exposing the historical findings to the reviewing session. Also test on unrelated small/medium diffs to avoid tuning only to this MR. Preserve historical results as-is.
