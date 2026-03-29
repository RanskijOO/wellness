# Google Play Data Safety Draft

Use this as the working draft when filling the Data safety form in Play Console. Review against the exact production build before submitting.

## App Scope

- App name: Aloe Wellness Coach
- Package: `com.aloe.wellness.aloe_wellness_coach`
- Positioning: wellness / lifestyle support app, not a medical app or medical device

## Data Likely Collected

Declare these only if they remain enabled in the production build and backend configuration:

- Personal info:
  - Email address for optional account sign-in and sync
- Health and fitness:
  - Water intake
  - Sleep entries
  - Weight entries
  - Mood entries
  - Wellness notes
  - Plan adherence / streak-style activity tied to wellness tracking
- App activity:
  - Product page opens
  - Outbound click events
  - Basic interaction analytics hooks
- App info and performance:
  - Crash/debug diagnostics
  - App version
  - Device / OS level diagnostics reasonably required for support and stability
- Device or other IDs:
  - Push token, if notifications are enabled
  - Auth/backend identifiers needed for sync

## Data Handling Purpose Mapping

Suggested purposes:

- App functionality:
  - account sign-in
  - syncing profile, logs, reminders, consents, and plans
  - providing reminders and push notifications
- Analytics:
  - outbound click tracking
  - basic feature usage understanding
- Developer communications:
  - support follow-up when users contact support
- Fraud prevention, security, and compliance:
  - auth/session protection
  - consent record retention

## Sharing

Suggested draft:

- Data is not sold.
- Data may be processed by service providers used to operate the app, including Supabase and Firebase.
- If your final Play interpretation counts this as "shared" under Google definitions, answer accordingly and keep it consistent with the production SDKs and backend behavior.

## Security / Handling Questions

Suggested answers if they remain true in production:

- Data is encrypted in transit: Yes
- Users can request deletion of their data: Yes
- Deletion web resource: `https://ranskijoo.github.io/wellness/account-deletion/`
- Privacy policy URL: `https://ranskijoo.github.io/wellness/privacy-policy/`
- Support email for privacy/deletion requests: `ranskijoo@gmail.com`

## Manual Verification Before Submission

- Confirm whether crash and analytics signals are actually transmitted in production or only scaffolded.
- Confirm whether push tokens are stored server-side in the shipping build.
- Confirm whether any third-party SDK declares additional collected/shared data in Google Play SDK Index guidance.
- Ensure the final answers match the exact release artifact uploaded to Play.
