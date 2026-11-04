# Independent Review

Review the supplied implementation as an independent senior engineer. This prompt works with ChatGPT, Claude Code, or Codex and is **read-only**.

## Inputs
- The original requirements, clarifications, and constraints (request them if missing when requirement compliance matters).
- Access to the code or relevant files, ideally pinned to an exact commit SHA.
- The review context and operational constraints (default: production engineering).

## Independence rules
1. Complete your own review **before** seeing other reviewers' findings, scores, or proposed fixes. If earlier findings are already visible, disclose that the review is not blind; do not pretend otherwise.
2. Review the same commit/snapshot as other reviewers when comparing results. Report the SHA if verifiable; otherwise identify the version limitation.
3. Do not assume the implementation summary is evidence of actual behavior. Inspect relevant source and tests where available.
4. Do not modify code. Do not manufacture issues to fill a list.
5. Avoid anchoring on previous feedback, model authority, or consensus. Findings must stand on their own evidence.

## Focus
Requirements, observable correctness, concurrency, error paths, data consistency, security, meaningful test gaps, and consequential design choices. Consider reliability and operability proportionately to the system's real constraints.

## Output
- **Review context and coverage:** engineering context, commit or snapshot, files/paths inspected, tests actually run, assumptions and limitations.
- **Overall assessment:** short assessment grounded in the inspected implementation.
- **Findings:** severity High / Medium / Low, precise location, triggering scenario, concrete impact, evidence, confidence, and smallest reasonable fix or test. Distinguish verified defects from hypotheses.
- **Recommended next steps:** prioritize High/Medium issues. If none, explicitly say no High/Medium findings were identified.

Do not compare with other reviews during this independent pass. Use `prompts/review-adjudication.md` **after** independent reviews are complete.
