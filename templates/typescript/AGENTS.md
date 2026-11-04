# TypeScript / JavaScript Project Agent Instructions (Template)

Use alongside the [general engineering template](../AGENTS.md), adapted to this repository. Inspect the existing stack, package manager, runtime, module system and conventions before changing code. Do not assume a particular framework, test runner or package manager.

## Language and runtime
- Prefer TypeScript where the project already uses it; do not convert JavaScript files or introduce TypeScript without a reason.
- Respect the repository's TypeScript configuration and existing lint/format rules. Prefer precise types; avoid `any`, unsafe assertions, and non-null assertions unless justified.
- TypeScript types are erased at runtime. Validate untrusted input at boundaries (HTTP, environment, queues, files, external APIs); use existing validation libraries if present.
- Model missing, invalid and failed states explicitly. Avoid silently coercing or replacing unknown values with defaults.
- Preserve existing ESM/CommonJS conventions, import paths and supported Node/browser versions. Do not add dependencies for trivial helpers.
- Do not log credentials, tokens or sensitive payloads. Keep secrets server-side.

## Async behavior and resource lifecycle
- Handle rejected promises and asynchronous failures; do not fire-and-forget important work without deliberate error handling.
- Propagate cancellation and timeouts when supported (for example `AbortSignal`); release timers, streams, sockets, listeners and other resources.
- Consider concurrency limits, ordering, retries and idempotency for external effects. Avoid unbounded `Promise.all` on large or uncontrolled workloads.
- Check API compatibility and error semantics when changing public interfaces.

## Structure and maintainability
- Follow existing module boundaries and naming conventions; keep functions and components focused.
- Prefer simple explicit control flow over clever abstractions. Avoid speculative generic frameworks.
- Use comments for non-obvious invariants and constraints, not line-by-line narration.
- Keep browser and server responsibilities separated when the application has both.

## Testing and validation
- Add focused deterministic tests for changed behavior, including failures, edge cases, input validation and async cancellation when relevant.
- Use the existing runner (e.g. Vitest, Jest, Node test runner) and repository scripts; do not assume a specific tool is installed.
- Mock external boundaries when appropriate; use isolated integration tests when real contracts, persistence or network semantics matter.
- Prefer behavior-oriented assertions; do not weaken tests or add arbitrary sleeps to make failures disappear.
- Run only documented, available lint, type-check, test and build commands. Report what actually ran and any limitations.

## Repository specifics to fill in
- Purpose, modules and runtime targets:
- TypeScript / JavaScript versions and module system:
- Package manager and lockfile:
- Lint, format, type-check, test and build commands:
- Environment variables and safe local test dependencies:
- Public API and compatibility requirements:
