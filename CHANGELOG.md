# Changelog

Notable changes to Engineering Toolkit, including its early development history.

This is a curated feature history, not a verbatim commit log. Dates describe development milestones, **not retroactive releases or version tags**.

## [Unreleased]

## [0.1.0] - 2026-11-04

Initial public release of Engineering Toolkit, including nine reusable skills, seven specialist agents, Codex and Claude Code adapters, and shared instruction templates.

### Added
- Provider-neutral code, test, JVM concurrency, and architecture review workflows, plus experimental agentic review variants.
- Independent second-opinion and findings-adjudication skills.
- Specialist agents for code exploration, databases, deployment, distributed systems, JVM concurrency, language-specific review, and security.
- Agent installation, skill installation, and structural validation scripts.
- GitHub Actions validation and installer smoke tests.

### Improved
- Consistent installer status and summary output, symlink conflict detection, and portable shell behavior.
- Consolidated documentation and installation guidance.

## 2026-11-04 — Public Engineering Toolkit repository

### Added
- Established the standalone `engineering-toolkit` repository with reusable engineering skills, agents, adapters, scripts, and templates.
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

- Historical entries are reconstructed from development commits and subsequent repository changes.
- The public repository's own Git history begins in November 2026; earlier entries document the toolkit's development milestones.
- Future noteworthy changes should be recorded under **Unreleased** using **Added**, **Changed**, **Fixed**, **Removed**, or **Security** as appropriate.
- Numbered release entries summarize shipped functionality; historical milestone entries below retain their original dates and are not retroactive version tags.
