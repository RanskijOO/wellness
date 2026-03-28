# Data Handling Explanation

This document is intended to help complete App Store privacy disclosures, Google Play Data safety, reviewer notes, and public legal pages.

## Product Scope

Aloe Wellness Coach is positioned as a wellness and lifestyle support app.

It handles user-entered wellness routine data such as:
- hydration logs
- sleep entries
- weight entries
- mood entries
- notes
- reminder settings
- plan adherence and streak data

It should not be described as a medical record or clinical monitoring system.

## Data Categories by Feature

### Account and authentication

- Email address
- Auth identifier
- Session metadata needed for sign-in and sync

Purpose:
- account access
- cross-device sync
- password reset and support

### Wellness profile and onboarding

- selected goals
- onboarding answers
- hydration and sleep baseline
- optional starting weight
- personal note

Purpose:
- personalize plan structure
- initialize routine targets

### Daily tracking

- water
- sleep
- weight
- mood
- notes
- checklist completion

Purpose:
- user progress tracking
- dashboard, charts, streaks, and plan adherence

### Notifications and reminders

- reminder preferences
- scheduled reminder times
- push token when push is enabled

Purpose:
- deliver local notifications and push reminders

### Product interactions

- product page opens
- outbound clicks
- source surface

Purpose:
- analytics
- support/debugging
- understanding which guidance blocks are useful

### Diagnostics and technical events

- app version
- device/OS context
- error or crash information
- minimal analytics events

Purpose:
- app stability
- performance monitoring
- fraud/security investigation

## What the App Should Not Claim

Avoid declaring or implying that the app:
- diagnoses disease
- treats medical conditions
- prevents disease
- replaces professional healthcare
- provides clinically validated individualized treatment recommendations

## User-Facing Explanations

The app should clearly tell users that:
- data is used to personalize plans and save progress
- reminders are optional
- external product pages open outside the app’s own service boundary
- legal documents and consent language are accessible before or during onboarding

## Store Form Notes

### Apple App Privacy

Before submission, verify:
- each collected data category is declared accurately
- tracking is declared correctly if third-party tracking is introduced
- diagnostics, identifiers, and user content are only declared if actually collected in the release build

### Google Play Data Safety

Before submission, verify:
- the published privacy policy matches actual collection, sharing, and retention
- health-related data is disclosed consistently with the release build
- the Health apps declaration is completed if the app remains in scope as a health-related app

## Operational Notes

- Publish the privacy policy on a public HTTPS page
- Keep in-app disclosures, store forms, and backend implementation aligned
- Review new SDKs before release because ad, analytics, or support SDKs can change store disclosure obligations
