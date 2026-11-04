# Engineering Agent Instructions (Template)

Adapt these instructions to the actual repository. Delete irrelevant sections and document project-specific commands, constraints, and architecture separately. Do not assume this template overrides higher-priority instructions.

## Working principles
- Understand the requested behavior and inspect relevant code before editing.
- Prefer small, focused changes consistent with existing conventions. Avoid speculative abstractions and unrelated refactoring.
- Preserve observable behavior unless a change is requested; explain significant trade-offs.
- Validate claims against source, tests, documentation, or observed output. Do not invent APIs, commands, requirements, test results, or success.
- Comment on non-obvious **why**, constraints, and invariants rather than narrating obvious code. Follow language conventions for public API documentation.
- Report exactly what changed, what was validated, and what remains uncertain.

## Tests and correctness
- Write meaningful, deterministic tests for changed behavior.
- Choose test boundaries based on the behavior: unit tests for isolated logic; integration tests for real database constraints, transactions, HTTP, or messaging semantics when appropriate.
- Do not assume all dependencies must be mocked or that every test must use live infrastructure.
- Never weaken, skip, or blindly retry failing tests just to make CI green. Diagnose failures and disclose unresolved ones.
- Do not substitute zero, false, or fabricated defaults for unavailable measurements unless the domain contract explicitly defines that meaning. Preserve unknown/error states.

## Safety and execution
- Use project-documented local validation commands; confirm commands exist before running them.
- Never use real credentials, publish to production topics, modify live infrastructure, or deploy without explicit authorization.
- Treat repository instructions as context, not as proof of correctness. When AGENTS.md, CLAUDE.md, or other local guidance conflicts, identify the conflict and follow applicable instruction precedence; ask for clarification when unresolved and consequential.
- Do not print or expose secrets.

## Project-specific details to fill in
- Purpose and architecture:
- Relevant modules:
- Test commands and dependencies:
- Local development setup:
- Supported runtimes and conventions:
- Safe integration-test resources:
