# AGENTS.md

## Global build rules

- Always produce working code, not only plans.
- After every major implementation step, run tests and fix failures.
- Keep the repository commercially presentable.
- Prefer maintainable production structure over hacks.
- Keep dependencies minimal and justified.
- Update README when setup or architecture changes.
- Use English for code comments and engineering documentation.
- Use Ukrainian for all user-facing UI text.

## Product rules

- This app is a wellness coach, not a medical app.
- Do not use diagnosis, treatment, cure, prevention, prescription, or medical
  device wording.
- Use soft wellness language.
- Include disclaimer, privacy policy, terms, and explicit consent flow.
- Use external product URLs instead of in-app supplement checkout in MVP.
- Support 7-day, 14-day, and 21-day plans.
- Track water, sleep, weight, mood, notes, and adherence.
- Use rule-based recommendations first.
- Keep architecture ready for future AI assistant integration.

## Architecture rules

- Flutter latest stable
- Riverpod
- GoRouter
- Supabase
- Firebase Cloud Messaging
- Local notifications
- Clean architecture
- Feature-first folder structure
- Reusable design system
- Dark mode support
- Offline-friendly behavior where reasonable

## Quality rules

- Add validation everywhere needed.
- Add loading, empty, error, and success states.
- Avoid placeholder-looking UI in final output.
- Add unit tests for critical business logic.
- Add widget tests for core flows.
- Verify navigation and seeded data work.

## Security and privacy rules

- Request only required permissions.
- Keep data collection minimal.
- Add privacy-first explanations in onboarding and settings.
- Document environment variables in `.env.example`.

## Before finishing

Verify:

- project builds
- tests pass
- navigation works
- Supabase schema is included
- seed content is included
- legal screens exist
- store metadata draft exists
- repository is presentable for handoff
