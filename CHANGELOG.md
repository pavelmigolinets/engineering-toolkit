# Changelog

Notable changes to Engineering Toolkit, including its engineering-focused development before the repository was separated from the private Interview Toolkit.

This is a curated feature history, not a verbatim commit log. Historical entries before 2026-11-04 refer to work originally committed in `pavelmigolinets/interview-toolkit`; interview-specific playbooks, project-review tooling, and exercise scaffolding are deliberately excluded. Dates describe development milestones, **not retroactive releases or version tags**.

The toolkit has not yet declared a numbered release in this changelog.

## [Unreleased]

### Added
- Historical engineering-only changelog reconstructed from the original and current repository histories.

## 2026-11-04 — Public Engineering Toolkit repository

### Added
- Established the standalone `engineering-toolkit` repository with reusable engineering skills, agents, adapters, scripts, and templates, separate from private interview workflows.
- Added `independent-review` for blind, read-only second opinions and `review-adjudication` for evidence-based verification of review findings.

### Changed
- Updated the agentic code-review workflow to support opt-in Markdown reports and explicit report output options.

## 2026-11-02 — Agentic workflows and cross-language support

### Added
- Experimental agentic code-review workflow with selective specialist delegation.
- Specialist agents for code exploration, databases, deployment, distributed systems, JVM concurrency, language-specific review, and security, with Claude Code and Codex adapters.
- Agentic architecture-review workflow and an agent catalog documenting roles.
- A/B review benchmark guidance, including comparison of conventional and agentic reviews and verification of findings.
- Reusable TypeScript/JavaScript and React/Next.js `AGENTS.md` templates.
- Toolkit structure validation tooling.

### Changed
- Refined agent selection, evidence requirements, and finding adjudication to reduce speculative review findings.
- Improved agentic review orchestration to wait for specialist results and produce a single consolidated report.
- Made the agent installer executable.

## 2026-10-20 — Skill discoverability

### Added
- Usage documentation and help mode for engineering skills, including code review, test review, test writing, architecture review, and JVM concurrency review.

## 2026-10-15 — Reusable engineering review foundations

### Added
- Language-agnostic `code-review` skill, supporting full, scoped, and changed-code review modes.
- Review depth controls and token-efficient investigation guidance.
- `test-review`, `test-writing`, `jvm-concurrency-review`, and provider-neutral `architecture-review` skills.
- Shared skill installation support for Codex and Claude Code.
- General and Go-specific `AGENTS.md` instruction templates.
- Blind independent-review and evidence-based review-adjudication prompts, later formalized as standalone skills in Engineering Toolkit.

### Changed
- Refined review and test-writing guidance around safe test execution, instruction conflicts, and behavior-focused tests.
- Documented how to choose an appropriate engineering skill rather than running every review by default.

---

### History and versioning

- Historical entries are based on engineering-related commits from the original private repository and subsequent commits in the standalone repository.
- The public repository's own Git history begins in November 2026; this changelog records earlier provenance without importing private interview history.
- Future noteworthy changes should be recorded under **Unreleased** using **Added**, **Changed**, **Fixed**, **Removed**, or **Security** as appropriate.
- When a release is actually tagged, move its entries into a dated version section. Do not assign version numbers to the historical milestones above retroactively.
