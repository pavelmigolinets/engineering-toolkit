---
name: test-writing
description: Write or improve focused automated tests for existing code using the project's test framework and conventions. Covers behavior, boundaries, failures, and concurrency where relevant; changes tests only by default.
---
# Test Writing

Act as a pragmatic software engineer writing maintainable, high-value automated tests. Work on the current checkout; do not compare Git branches unless explicitly asked.


## Help mode

If the invocation is `help`, `--help`, or a request to show usage/options, **only display the Usage section below**, with defaults and examples. Do not inspect the repository, run tests, perform the skill's normal task, or edit files. Treat these as natural-language requests, not CLI flags parsed by a tool. Replace `$skill-name` with `/skill-name` in Claude Code.

## Usage

Invoke `$test-writing` in Codex or `/test-writing` in Claude Code. For options, use `$test-writing help` or `/test-writing help`. Options below are **natural-language instructions**, not validated CLI arguments.

- **Mode:** `focused` (default), `gap filling`, `regression`.
- **Scope:** requested function, file, component, or behavior.
- **Scenario:** optional specific bug, boundary, or expected outcome.
- **Constraints:** optional test framework, existing fixtures, isolation requirements; tests and fixtures only by default.
- **Validation:** run targeted tests, broader relevant suite when practical.

Examples:
```text
$test-writing Scope: SupplierOfferService; Scenario: invalid input
$test-writing Mode: gap filling; Scope: SupplierOfferRepository; Focus: transactions
$test-writing Mode: regression; Scenario: duplicate insert bug; Constraints: tests only
```

## Scope and constraints
- Write or improve tests for the requested function, class, package, feature, or defect. Ask for clarification only if the intended behavior cannot be established from requirements, code, or existing tests.
- **Modify test files and necessary test fixtures only by default.** Do not change production code, dependencies, build configuration, snapshots, or test infrastructure without explicit permission. If a test exposes a production bug, report it instead of silently fixing production code.
- Check repository guidance for conflicts (including AGENTS.md and CLAUDE.md). Follow applicable instruction precedence; if unresolved instructions materially conflict, ask before choosing. Follow the existing language, framework, naming, mocking, and assertion conventions. Do not introduce a new testing framework or library without permission.
- Do not delete or weaken existing assertions to make tests pass. Do not modify unrelated tests.

## Approach
1. Inspect the target implementation, its observable contract, relevant dependencies, and nearby tests.
2. Identify a small set of important scenarios: expected behavior, boundary and invalid inputs, error handling, and meaningful state transitions. Add concurrency, cancellation, timeouts, idempotency, or cleanup scenarios **only when relevant**.
3. Choose the lowest appropriate test level that **actually validates the contract**: unit tests for isolated logic, integration tests with isolated real dependencies when correctness depends on SQL, transactions, constraints, HTTP, or messaging behavior, and contract tests when an interface contract warrants them. Neither mock all dependencies nor require real infrastructure for every test. Never use live production systems or credentials for routine tests.
4. Make assertions about externally observable outcomes, including errors and side effects; avoid tests that merely restate implementation details or verify incidental mock calls.
5. Keep tests deterministic and isolated. Avoid arbitrary sleeps, uncontrolled time, network access, shared mutable fixtures, and ordering dependencies. Use existing fake clocks, test containers, fixtures, and synchronization primitives where appropriate.
6. Implement the minimal focused tests. Prefer table-driven/parameterized tests when they improve clarity, not as a blanket rule.
7. Do not weaken, skip, or blindly retry failing tests just to make CI green. Preserve unknown/error states; never invent zero or false measurements to fill missing data unless the contract explicitly requires that meaning. Run targeted tests and report the exact command and result. If practical, run the broader relevant suite. If tests fail, diagnose whether the cause is test setup, an existing production defect, or environment constraints. Do not conceal failures.
8. Stop once the requested behavior is covered with meaningful assertions; do not chase coverage percentages or generate redundant tests.

## Modes
- **Focused (default):** Add tests for the requested behavior or defect, with minimal changes.
- **Gap filling:** Add the most valuable missing scenarios for an existing component based on its contract and current tests.
- **Regression:** Reproduce a reported bug with a test that fails against the defective behavior when feasible; do not change production code unless explicitly requested.

## Output
Summarize test files changed and behaviors covered, commands run with pass/fail outcomes, uncovered risks or assumptions, and any production bugs discovered. If validation could not run, say why. Do not claim tests pass without executing them.
