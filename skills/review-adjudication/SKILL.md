---
name: review-adjudication
description: Read-only verification of existing code review findings, false positives, reviewer disagreements, and whether issues were addressed in current code.
---

# Review Adjudication

Verify existing findings against actual code and tests. Reviewer agreement, reputation, and resolved PR threads are not proof. Do not modify files or post review comments.

## Help mode

For `help`, `--help` or usage requests, display only Usage; do not inspect code or findings. Options are natural-language instructions, not CLI arguments.

## Usage

Use `$review-adjudication` in Codex or `/review-adjudication` in Claude Code.

- **Findings:** required file path, pasted report, or accessible PR/MR review comments.
- **Mode:** `verify` (default, one review), `compare` (multiple reviews), `recheck` (after fixes).
- **Snapshot:** target commit SHA or current checkout (report which).
- **Original snapshot:** optional SHA used by original reviewer.
- **Depth:** `quick`, `standard` (default), `deep`.
- **Focus:** optional finding IDs, severity or subsystem.

```text
$review-adjudication Findings: review.md; Mode: verify; Snapshot: HEAD
$review-adjudication Findings: claude.md, codex.md; Mode: compare; Snapshot: abc123
$review-adjudication Findings: review.md; Mode: recheck; Original snapshot: abc123; Snapshot: HEAD
```

## Verification

1. Obtain the findings; ask for them if missing. Identify original and target snapshots and requirements. If reviewers used different commits, distinguish version changes from disagreements.
2. Normalize and deduplicate claims by root cause while preserving each source.
3. For each claim inspect relevant code, callers, tests, configuration, transaction boundaries and recovery paths. Verify reachability, trigger, impact and whether a proposed fix actually works. Run only safe non-destructive validation.
4. Classify as **Confirmed**, **Plausible / needs verification**, **Not supported**, or **Out of scope**. For rechecks, also use **Addressed** and **Partially addressed** where supported by current code evidence.
5. Reassess severity from impact and likelihood, not reviewer votes. A resolved thread alone is not evidence of a fix.
6. If remote PR/MR comments are requested, fetch them only with an available configured read-only connector; disclose unavailable access. Never post, resolve, approve, or change review state.

## Output

- **Evidence and versions:** target SHA, original snapshot(s), sources, validation actually run, limitations.
- **Adjudication table:** issue, reviewer/source, status, `file:line` evidence, final severity, action.
- **Disagreements:** false positives, duplicates, substantive conflicts and assumptions.
- **Prioritized next steps** and residual uncertainty.

If no actionable issues survive verification, state that explicitly. Do not manufacture consensus.
