# Aloe Wellness Coach

Production-oriented Flutter mobile app for iOS and Android focused on wellness routines, hydration, sleep, mood, adherence, and Forever Living-inspired product guidance.

## What Is Included

- Flutter 3.41.6 app scaffolded for Android and iOS
- Clean feature-first architecture with Riverpod and GoRouter
- Ukrainian-first UI with localization plumbing ready for English
- Demo-first runtime that works without live Supabase/Firebase credentials
- Supabase schema, migration, seed content, and config
- Firebase Cloud Messaging and local notification scaffolding
- Product catalog, plan engine, trackers, reminders, legal flow, outbound click tracking, and analytics hooks
- Unit tests, widget tests, basic integration smoke test, and CI workflow

## Core Product Scope

- Onboarding with goals, questionnaire, baselines, disclaimer, privacy consent, and terms acceptance
- Email auth, sign-up, password reset, and guest mode
- Dashboard with today plan, water ring, sleep/mood/weight snapshot, notes, quick actions, reminders, and recommendations
- 7 / 14 / 21-day wellness programs with checklist-based adherence
- Trackers for water, sleep, weight, mood, notes, and streaks
- Product catalog with category filters, search, external/shop-ready links, and in-app webview support
- Live Ukrainian Aloe Hub storefront used as the product source of truth, with the provided PDF used only to enrich matched items with stronger metadata
- Profile, reminder time editing, theme settings, privacy policy, terms, disclaimer, and support
- Friendly loading, retry, empty, and offline-aware states across the core surfaces

## Tech Stack

- Flutter stable `3.41.6`
- Riverpod
- GoRouter
- Supabase
- Firebase Core + Firebase Messaging scaffold
- flutter_local_notifications
- flutter_secure_storage
- shared_preferences
- fl_chart
- url_launcher + webview_flutter

## Repository Structure

```text
lib/
  app/                  bootstrap, router, providers
  core/                 config, content, design system, services, widgets
  features/
    auth/
    dashboard/
    goals/
    onboarding/
    plans/
    products/
    profile/
    trackers/
  l10n/
assets/
  env/
supabase/
  migrations/
  seed.sql
docs/
  setup/
  legal/
  release/
integration_test/
test/
```

## Quick Start

### 1. Prerequisites

- Flutter `3.41.6` or newer stable
- Dart `3.11.4`
- Android SDK for APK builds
- Xcode for iOS builds on macOS
- Supabase project for production auth/data sync
- Firebase project for production push notifications

### 2. Environment File

The app ships with `assets/env/app.env` for demo mode.

For production, copy the template:

```bash
Copy-Item .env.example assets/env/app.env
```

Then fill in the real values for:

- `ENABLE_SUPABASE`
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`
- `ENABLE_FIREBASE`
- `FIREBASE_API_KEY`
- `FIREBASE_ANDROID_APP_ID`
- `FIREBASE_IOS_APP_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_STORAGE_BUCKET`
- `SHOP_BASE_URL`
- `SUPPORT_EMAIL`

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run
```

Demo mode works even with Supabase/Firebase disabled. Live sync and push require real configuration.

### 5. Supabase Setup

```bash
supabase db push
supabase db reset --linked
```

Files:

- `supabase/migrations/20260328160000_initial_schema.sql`
- `supabase/seed.sql`
- `supabase/config.toml`

Detailed notes: [docs/setup/supabase_setup.md](/D:/wellness/docs/setup/supabase_setup.md)

### 6. Firebase Setup

Use real project credentials and native config files before release:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

Detailed notes: [docs/setup/firebase_setup.md](/D:/wellness/docs/setup/firebase_setup.md)

### 7. Android Release Signing

The Android release build now supports a dedicated upload key through:

- `android/key.properties`
- `android/upload-keystore.jks`
- `android/key.properties.example`

Notes:

- `android/key.properties` and `android/upload-keystore.jks` are gitignored and should not be committed.
- Keep a secure backup of the upload keystore and its passwords.
- If `android/key.properties` is missing, the repo can still fall back to debug signing locally, but that is not acceptable for Google Play submission.

## Quality Commands

```bash
flutter analyze
flutter test
flutter test integration_test
flutter build apk --debug
```

Notes:

- `flutter test integration_test` needs a supported device or emulator.
- iOS build verification must be done on macOS.

## Current Verification Status

- `flutter analyze`: passes
- `flutter test`: passes
- `flutter test integration_test`: test exists, but execution requires a connected device/emulator
- Android build: `flutter build apk --debug` passes

## Troubleshooting

- If the app opens in demo mode only, verify `assets/env/app.env` and confirm `ENABLE_SUPABASE` / `ENABLE_FIREBASE` are set correctly.
- If reminder times do not behave as expected on a real device, run a physical-device notification QA pass before release.
- If store/legal reviewers ask for accessible policy flows, legal routes are available in-app before account creation through the auth and onboarding flows.
- If a product page fails to open, verify the configured external URL is absolute and reachable.

## Product Safety Positioning

- The app is a wellness and lifestyle product, not a medical app
- All copy avoids diagnosis, treatment, cure, or disease claims
- Product recommendations are framed as general wellness support only
- Disclaimer, privacy, terms, and consent are included in both UI and docs

## Deployment Notes

- Default shop links now point to the Ukrainian Aloe Hub storefront at `https://aloe-hub.flpuretail.com/uk/`
- If you use another distributor storefront, replace `SHOP_BASE_URL` and refresh the catalog URL mapping before release
- Add brand-final app icon and launch assets before store submission
- Configure Supabase RLS review, backups, and environment separation
- Connect Firebase FCM/APNs certificates before push release

## Release Docs

- [Production TODO](/D:/wellness/docs/production_todo.md)
- [App Store Metadata](/D:/wellness/docs/release/app_store_metadata.md)
- [Google Play Metadata](/D:/wellness/docs/release/google_play_metadata.md)
- [Google Play Data Safety Draft](/D:/wellness/docs/release/google_play_data_safety.md)
- [Google Play Health Declaration Draft](/D:/wellness/docs/release/google_play_health_declaration.md)
- [Screenshot Plan](/D:/wellness/docs/release/screenshot_plan.md)
- [Release Checklist](/D:/wellness/docs/release/release_checklist.md)
- [Privacy Policy Template](/D:/wellness/docs/legal/privacy_policy_template.md)
- [Privacy Policy Publishing](/D:/wellness/docs/setup/privacy_policy_publishing.md)
- [Terms Template](/D:/wellness/docs/legal/terms_template.md)
- [Data Handling Explanation](/D:/wellness/docs/legal/data_handling_explanation.md)
- [Reviewer Notes Draft](/D:/wellness/docs/release/reviewer_notes_draft.md)
- [Wellness Compliance Notes](/D:/wellness/docs/release/compliance_notes.md)
