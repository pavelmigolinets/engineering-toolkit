# Go Project Agent Instructions (Template)

Use alongside the general engineering template, adapted to this repository. Project-specific conventions and commands take precedence where compatible with higher-priority instructions.

## Go conventions
- Follow existing code conventions and run `gofmt` on modified Go files.
- Prefer explicit, simple control flow and early returns when clearer.
- Wrap errors with useful context; use `errors.Is` and `errors.As` for identity/type checks.
- Propagate `context.Context` for cancellable operations; handle cancellation and resource cleanup.
- Use small interfaces at genuine abstraction boundaries; avoid speculative interfaces.
- Use appropriate synchronization for shared state and test meaningful concurrent behavior.
- Write comments for non-obvious intent, invariants, and exported API contracts when needed; do not add narration above every function.

## Go testing
- Follow existing testing conventions (`testing`, testify, or other libraries already in use).
- Prefer table-driven tests/subtests when they make distinct scenarios easier to understand.
- Keep tests deterministic; use explicit synchronization rather than sleeps for concurrency tests.
- Consider `go test -race` for relevant concurrency changes when feasible.
- Use real isolated dependencies when testing persistence or integration semantics; use mocks/fakes when isolation better matches the behavior.
- Run the repository's documented test command. Do not assume a Taskfile or Docker Compose exists.

## Repository specifics to fill in
- Go version:
- Test commands:
- Integration-test dependencies:
- Entry points and packages:
