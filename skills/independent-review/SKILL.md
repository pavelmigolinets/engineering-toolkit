---
name: independent-review
description: Blind, read-only second opinion on code or changes, in a fresh session without exposure to previous review findings.
---

# Independent Review

Act as an independent senior engineer. Inspect source, tests and relevant call paths rather than trusting summaries. Never modify code, tests, branches, or review threads.

## Help mode

For `help`, `--help` or a usage request, show only the Usage section. Do not inspect the repository. Options are natural-language instructions, not a CLI.

## Usage

Use `$independent-review` in Codex or `/independent-review` in Claude Code.

- **Mode:** `full` (default), `scoped`, `changes`
- **Depth:** `quick`, `standard` (default), `deep`
- **Scope:** optional paths, components or behavior
- **Target:** comparison branch/commit for `changes` (default `main` if present)
- **Focus:** optional correctness, concurrency, reliability, security, performance or tests

```text
$independent-review Mode: changes; Target: main; Depth: deep
$independent-review Mode: scoped; Scope: SupplierOfferService; Focus: transactions
```

## Independence contract

1. Run in a **fresh session** without prior findings, review reports, PR review comments or scores. Invoking another skill in the same conversation does not make a review blind.
2. If prior findings are already visible, disclose compromised independence. Do not pretend the review is blind; recommend a fresh session.
3. Prefer the same immutable commit SHA used by other reviewers; record the verified SHA or disclose snapshot limitations.
4. Do not fetch or inspect previous review comments or reports during the independent pass.
5. Respect repository instructions and review read-only. Run only non-destructive tests when useful; disclose what actually ran.

## Process

Establish mode, scope, depth and target snapshot. Inspect relevant implementation, callers, error paths, concurrency, persistence, configuration and tests. Expand investigation only to substantiate a concrete concern. Distinguish confirmed defects from plausible risks and test gaps; avoid style-only issues, speculative findings and duplicates.

## Output

- **Coverage:** mode, depth, snapshot SHA, inspected areas, validation performed, limitations.
- **Findings:** severity Critical / High / Medium / Low, `file:line`, reachable trigger, evidence, impact, confidence, smallest practical fix/test.
- **Assessment:** prioritized next actions and remaining uncertainty.

If no meaningful issues are found, state **"No actionable findings identified."** Do not compare with other reviews until this review is finished. Use `review-adjudication` afterward.
