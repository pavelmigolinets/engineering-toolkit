---
name: test-review
description: Review existing tests and test gaps for correctness, meaningful edge cases, failure behavior, flakiness, and assertion quality. Use for a focused test audit; read-only.
---
# Test Review

Act as a critical, pragmatic senior engineer. Review the tests for the user's specified files, component, or repository. Default to the current implementation, without a Git comparison. If explicitly requested, review changes against a named branch. State the scope and coverage limitations.


## Help mode

If the invocation is `help`, `--help`, or a request to show usage/options, **only display the Usage section below**, with defaults and examples. Do not inspect the repository, run tests, perform the skill's normal task, or edit files. Treat these as natural-language requests, not CLI flags parsed by a tool. Replace `$skill-name` with `/skill-name` in Claude Code.

## Usage

Invoke `$test-review` in Codex or `/test-review` in Claude Code. For options, use `$test-review help` or `/test-review help`. Options below are **natural-language instructions**, not validated CLI arguments.

- **Scope:** repository (default), or specified files, packages, components.
- **Comparison:** current code (default), or changes against a named branch when explicitly requested.
- **Focus:** optional test gaps, assertions, isolation, flakiness, concurrency, error paths.
- **Edits:** never; this skill is read-only.

Examples:
```text
$test-review
$test-review Scope: SupplierOfferRepository; Focus: transaction coverage
$test-review Comparison: main; Focus: regression tests
```

## Procedure
1. Identify the language, test framework, behavior under test, and relevant production code.
2. Inspect tests and their assertions; trace important success and failure paths.
3. Prioritize untested behavior with plausible user or production impact: boundary cases, invalid inputs, error propagation, concurrency, timeouts, cancellation, idempotency, and resource cleanup when applicable.
4. Flag tests that can pass while the behavior is broken, nondeterministic tests, overly coupled implementation assertions, and missing isolation. Assess whether mocks hide real database constraints, transactions, HTTP contracts, or messaging semantics. Do not demand real infrastructure for isolated unit logic.
5. Flag skipped, weakened, or blindly retried flaky tests that conceal failures; distinguish legitimate resilience to environmental instability from masking application defects. Verify that missing measurements are not represented as real zero/false values unless explicitly specified by the domain contract. Run targeted non-destructive tests when practical. Do not edit files or generate tests.
6. Expand investigation only to validate a concrete concern. Avoid coverage-percentage chasing, duplicate findings, and hypothetical edge cases with no meaningful impact.

## Output
Start with findings ranked High / Medium / Low. For each: file and line, missing or defective scenario, impact, suggested test or minimal correction, and confidence. Distinguish confirmed problems from potential risks. Conclude with validation performed and important coverage limitations. If nothing actionable is found, say "No actionable findings identified."
