# Global Claude Code Preferences

These are my default engineering standards. Apply them to every project unless a project's own CLAUDE.md overrides something explicitly.

## Default Stack

- Use Next.js, TypeScript, and React for web application projects by default.
- When the project domain doesn't fit that stack (data pipelines, Airflow DAGs, infra scripts, CLIs, etc.), use whatever language and framework is idiomatic for that domain instead (e.g. Python for Airflow DAGs). The stack choice is flexible; the practices below are not.
- Prefer the existing conventions of a repo over introducing a new tool or pattern, unless asked to change them.

## Testing

- Every feature or bug fix should come with tests. Nothing should be considered done without test coverage for its core logic.
- Unit test business logic; add integration or end-to-end tests for critical user flows and cross-service behavior.
- Use the standard test tooling for the language in use (e.g. Jest / React Testing Library / Playwright for TypeScript and Next.js; pytest for Python).
- Tests must run in CI and a failing test blocks merge.

## Linting and Formatting

- Every project should have linting configured and enforced (e.g. ESLint plus Prettier for TypeScript/JS; Ruff or Flake8 plus Black for Python).
- Linting runs both locally (pre-commit hook where practical) and in CI.
- Fix lint errors rather than suppressing them; if a rule needs disabling, do it narrowly and explain why in a comment.

## CI/CD

- Use GitLab CI for pipelines (`.gitlab-ci.yml`) unless a project is already on a different platform.
- Pipeline should at minimum: install dependencies, lint, run tests, and build. Add a deploy stage where relevant.
- Keep pipeline stages fast and cacheable; parallelize independent jobs where possible.
- Merge requests should not be mergeable if the pipeline is failing.

## Code Reuse and Structure

- Reuse existing utilities, components, hooks, and modules instead of duplicating logic. Search the codebase before writing something that might already exist.
- Extract shared logic into a common module/package once it's used more than once (or is clearly going to be).
- Keep functions and components small and single-purpose; favor composition over duplication.

## General Practices

- Write clear commit messages and keep merge/pull requests focused on one logical change.
- Document non-obvious decisions in code comments or a README, not just in chat.
- Prefer explicit types over `any` in TypeScript; avoid implicit `any`.
- Handle errors explicitly; don't swallow exceptions silently.
- Keep secrets and credentials out of source control; use environment variables or the project's secrets manager.
