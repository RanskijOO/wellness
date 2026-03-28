# Release Checklist

## Product

- Review all UI copy for wellness-safe wording.
- Verify no screen contains diagnosis, cure, treatment, or disease claims.
- Verify no screenshot, subtitle, short description, or promo text implies clinical benefit.
- Replace placeholder product URLs with live commerce destinations.
- Confirm disclaimer and consent are visible before primary usage.
- Confirm privacy policy, terms, and disclaimer can be opened before login/guest continuation.
- Confirm onboarding consent copy explains what data is stored and that product links may open on a third-party site.
- Verify auth validation for empty, invalid, and weak credentials.
- Verify onboarding cannot be skipped by swipe and blocks completion without all required consents.
- If iOS email account creation is enabled in the shipping build, verify in-app account deletion exists and is tested.

## Backend

- Run Supabase migration and seed on production.
- Verify RLS policies with real auth users.
- Confirm outbound click events are stored correctly.
- Verify remote config defaults and overrides.
- Verify reminder edits and program length changes sync back to Supabase for authenticated users.
- Remove unused permissions and SDKs that could change store disclosure requirements.

## Notifications

- Verify local reminders on Android and iOS.
- Verify edited reminder times persist after app restart.
- Verify FCM token registration.
- Test foreground, background, and tap-through push behavior.

## QA

- Run `flutter analyze`
- Run `flutter test`
- Run `flutter test integration_test` on a device or emulator
- Build Android debug and release artifacts
- Build iOS archive on macOS
- Test guest mode and email auth
- Test offline launch and local cache behavior
- Test invalid/empty webview URLs and retry states
- Test small-screen layouts, large phones, and dark mode contrast
- Test retry flows on dashboard, profile, plans, progress, and catalog screens
- Test that legal docs are readable and scroll correctly on small devices
- Test that guest mode gives review access to the main non-auth functionality

## Store Readiness

- Finalize app icon and launch assets
- Finalize screenshots
- Finalize App Store and Google Play metadata
- Publish privacy policy at a public HTTPS URL
- Publish the static `site/privacy-policy/` page or equivalent hosted policy before submitting
- Complete App Store privacy disclosures
- Complete Google Play Data safety form
- Complete Google Play Health apps declaration
- Validate support email and legal URLs
- Rehearse App Store / Play review notes emphasizing wellness-only positioning
- Confirm screenshots and store listing do not contain medical or misleading supplement claims
- Confirm reviewer notes mention guest mode or provide a working demo account
