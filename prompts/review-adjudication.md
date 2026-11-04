# Review Adjudication

Compare **completed, independent** code reviews from Codex, Claude Code, ChatGPT, or human reviewers. Do not treat agreement or model reputation as proof.

## Inputs
- Original requirements and relevant constraints.
- The exact code commit/snapshot each reviewer inspected.
- Each review's findings, including file/line, scenario, severity, and evidence.
- Source code and tests when available for verification.

If reviewers inspected different commits, flag this immediately; do not attribute disagreements to reviewer quality until version differences are resolved.

## Process
1. Normalize findings by underlying defect or risk, not by phrasing. Deduplicate overlapping claims while preserving independent evidence.
2. For each distinct claim, inspect relevant source/tests and reason through the triggering scenario. Run focused non-destructive tests if available and useful.
3. Classify the claim:
   - **Confirmed:** evidence demonstrates a real issue in the target version.
   - **Plausible / needs verification:** meaningful risk, but key evidence is missing.
   - **Not supported:** contradicted by code, requirements, or tests.
   - **Out of scope:** valid concern but not relevant to stated constraints.
4. Reconcile severity based on impact and likelihood, not number of reviewers who raised it.
5. Explain substantive disagreements, including assumptions, missing context, and why a claim is accepted or rejected.
6. Propose the smallest practical fix or targeted verification for confirmed and important plausible findings. Do not modify code.

## Output
- **Version and evidence check:** snapshots reviewed and comparability limitations.
- **Adjudication table:** issue, raised by, status, evidence/reasoning, final severity, recommended action.
- **Disagreements:** concise explanation of consequential conflicting opinions.
- **Prioritized next actions:** confirmed high-impact fixes first, then focused tests or questions.
- **Residual uncertainty:** what cannot be resolved without more code, requirements, or runtime evidence.

Do not create artificial consensus. If no actionable issues survive verification, say so explicitly.
