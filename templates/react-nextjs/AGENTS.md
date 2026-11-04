# React / Next.js Project Agent Instructions (Template)

Use alongside the [general engineering template](../AGENTS.md) and, where applicable, the [TypeScript/JavaScript template](../typescript/AGENTS.md). Adapt to the project's actual React, Next.js and routing versions. Do not assume the App Router, Server Components, a state library or a particular styling system.

## Components and rendering
- Follow existing component, routing, styling and state conventions; prefer small, accessible components with clear responsibilities.
- Keep rendering pure. Derive state instead of duplicating it; avoid effects for computations that belong in render or event handlers.
- Respect hook rules and dependency semantics; handle stale closures, cleanup and subscriptions. Do not suppress lint warnings without understanding them.
- Preserve stable keys and identities where needed; avoid premature memoization and broad rerenders without evidence.
- Support loading, empty, error and retry states where relevant. Avoid hiding errors behind misleading placeholders.

## Next.js boundaries (only when Next.js is present)
- Inspect the installed Next.js version and whether the project uses App Router, Pages Router or both.
- In App Router, prefer Server Components for server-side data access when suitable; introduce `"use client"` only where interactivity/browser APIs require it. Do not send secrets or server-only dependencies to the client.
- Respect server/client serialization boundaries, route handlers, server actions, middleware and authentication/authorization boundaries. A hidden UI control is not authorization.
- Check caching, revalidation and dynamic rendering semantics against the installed version and actual data freshness requirements; do not assume defaults.
- Handle redirects, navigation, metadata and errors using the project's established patterns.
- Avoid assuming Next.js-specific features apply to plain React or other frameworks.

## Data, security and accessibility
- Validate untrusted inputs at the server boundary and enforce authorization server-side. Protect against XSS and unsafe HTML injection.
- Use established data-fetching and mutation patterns; consider cancellation, race conditions, optimistic updates, duplicate submissions and invalidation.
- Prefer semantic HTML, keyboard access, visible focus, labels and meaningful error feedback. Use ARIA only when native semantics are insufficient.
- Consider responsive layouts and performance where relevant; measure before adding memoization, code splitting or caching complexity.

## Testing and validation
- Use existing test tools (e.g. React Testing Library, Vitest/Jest, Playwright/Cypress) and documented scripts; do not introduce tools by default.
- Test user-observable behavior and accessibility rather than component internals; cover loading, error and async interactions.
- Use integration/e2e tests for navigation, server/client integration, authentication and caching when those contracts are changed.
- Verify lint, type-check, unit tests and build where available. Report actual commands and unverified behavior.

## Repository specifics to fill in
- React and Next.js versions; App Router / Pages Router / neither:
- Rendering strategy and data-fetching conventions:
- Styling, forms, validation and state libraries:
- Authentication and authorization boundaries:
- Package manager, lint, type-check, test, e2e and build commands:
- Environment variables, test services and deployment constraints:
