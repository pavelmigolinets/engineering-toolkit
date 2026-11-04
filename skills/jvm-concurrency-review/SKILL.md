---
name: jvm-concurrency-review
description: Review Java or Kotlin concurrency correctness and runtime behavior, including synchronization, memory visibility, executors, virtual threads, futures, and coroutines. Read-only.
---
# JVM Concurrency Review

Act as a senior JVM concurrency specialist. Review the requested Java/Kotlin code on the current branch without a diff unless explicitly requested. Identify concrete defects, not stylistic preferences.


## Help mode

If the invocation is `help`, `--help`, or a request to show usage/options, **only display the Usage section below**, with defaults and examples. Do not inspect the repository, run tests, perform the skill's normal task, or edit files. Treat these as natural-language requests, not CLI flags parsed by a tool. Replace `$skill-name` with `/skill-name` in Claude Code.

## Usage

Invoke `$jvm-concurrency-review` in Codex or `/jvm-concurrency-review` in Claude Code. For options, use `$jvm-concurrency-review help` or `/jvm-concurrency-review help`. Options below are **natural-language instructions**, not validated CLI arguments.

- **Scope:** current Java/Kotlin code (default) or named classes, methods, execution paths.
- **Focus:** optional races, visibility, deadlocks, executors, CompletableFuture, virtual threads, coroutines, cancellation, backpressure.
- **Comparison:** current branch (default); branch diff only if explicitly requested.
- **Edits:** never; read-only.

Examples:
```text
$jvm-concurrency-review Scope: ResourcePool; Focus: races and shutdown
$jvm-concurrency-review Scope: Aggregator; Focus: CompletableFuture cancellation
```

## Analyze only applicable mechanisms
- Java Memory Model: happens-before, publication, visibility, atomicity, volatile, locks, concurrent collections, and mutable shared state.
- Executor and thread pool lifecycle: sizing, saturation, blocking, rejection, shutdown, interruption, and resource leaks.
- CompletableFuture: completion, exception propagation, cancellation, timeouts, blocking join/get, and unfinished tasks.
- Virtual threads: pinning where applicable, bounded downstream resources, and misuse of thread-local assumptions.
- Kotlin coroutines: structured concurrency, dispatcher usage, cancellation, exception propagation, shared mutable state, and blocking within suspending paths.
- Integration boundaries: database transactions, connection pools, remote calls, backpressure, and retries when relevant.

## Workflow
1. Determine Java/Kotlin versions and runtime/framework context from the repository.
2. Trace the relevant lifecycle and shared-state access paths, including callers and tests.
3. Explain exact interleavings or triggering conditions for suspected races, deadlocks, leaks, or liveness failures.
4. Validate against surrounding code; run non-destructive targeted tests or analysis when feasible.
5. Do not modify files. Avoid importing irrelevant Java mechanisms into Kotlin coroutine code or vice versa. Do not flag theoretical concerns without a plausible scenario.

## Output
Report severity-ranked actionable findings with file/line, trigger, impact, minimal fix, and confidence. Separate confirmed issues from assumptions. Summarize validation and any remaining uncertainty. If no meaningful issues are found, say "No actionable findings identified."
