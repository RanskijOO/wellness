# Firebase / Push Setup

## Required Components

- Firebase project
- Android app registered with package name `com.aloe.wellness.aloe_wellness_coach`
- iOS app registered with the matching bundle identifier
- APNs configuration for iOS push

## Files To Add

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

## Environment Variables

Set these in `assets/env/app.env`:

- `ENABLE_FIREBASE=true`
- `FIREBASE_API_KEY`
- `FIREBASE_ANDROID_APP_ID`
- `FIREBASE_IOS_APP_ID`
- `FIREBASE_PROJECT_ID`
- `FIREBASE_MESSAGING_SENDER_ID`
- `FIREBASE_STORAGE_BUCKET`

## Notes

- The current repository keeps Firebase initialization optional so the app still runs in demo mode without live credentials.
- Before production rollout, verify token registration, notification permissions, background delivery, and deep-link behavior from push notifications.
