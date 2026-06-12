# Privacy Policy — REMind-Ai

**Effective date:** May 2026
**Last updated:** June 2026

REMind-Ai ("the app", "we") is an independent hobby project developed by
**Liviu-Stefan Petroaia** ("the developer"). This policy explains what data
the app handles and how. We are not affiliated with any company.

Contact for any privacy question or data request:
**liviustefan.petroaia@gmail.com**

---

## 1. Who this policy applies to

This policy applies to everyone who uses REMind-Ai on the Web (currently the
primary platform) and on other platforms if and when they are offered. You
must be **18 years or older** to use the app — this is required by Google's
Gemini API Terms of Service, which power the interpretation feature.

## 2. What data the app handles

REMind-Ai does **not** require registration, email, password, or phone number
to use the free tier. We do **not** collect analytics, advertising IDs,
location, contacts, camera, microphone, or behavioural telemetry for our own
purposes.

The personal content you provide is the text **you** type into the dream
input field, plus the AI-generated interpretation returned for that text.

### Data stored on your device

- Your dream entries and their interpretations
- App preferences (theme, motion, onboarding state, age confirmation)
- Anonymous usage counters (daily interpretation limits)

This data is stored locally on your device in an encrypted Hive database.
The encryption key is held in the platform secure storage
(Android Keystore / Windows DPAPI / browser-local storage on Web). The
developer cannot read your local database.

You can wipe all locally stored data at any time through
**Settings → Clear dream history**, or by uninstalling the app / clearing
site data on the Web build.

### Data sent off-device

When you tap **Unravel It** (the "Interpret" action), the text of the
specific dream you submitted is sent over HTTPS to Google's Gemini models,
**routed through Firebase AI Logic** in the app's Google Firebase project, so
the AI model can produce an interpretation. Only the dream text and the
prompt parameters are sent. The interpretation returned by Google is shown
to you and stored locally.

We do not send your dream text to any other service for interpretation.
The developer does **not** routinely access, read, or store your dream text
on our own servers except as described for optional Pro cloud backup below.

### Anonymous sign-in and abuse protection

So that requests can be routed securely without embedding any secret key in
the app, REMind-Ai signs you in to Google Firebase **anonymously** in the
background on supported builds. This anonymous Firebase user identifier exists
only to authorise interpretation requests; it is not linked to your name or
email unless you later sign in with Google for Pro. It is discarded if you
clear site data or uninstall.

To prevent automated abuse of the AI service, requests are verified with
**Firebase App Check**. On the Web this uses **Google reCAPTCHA**, which
sends limited technical signals (such as interaction and browser metadata) to
Google for risk analysis; on Android it uses the Play Integrity API. This
protection processes no dream content.

We do **not** use these signals for advertising or profiling. They are
technical safeguards only.

### Optional Pro tier (off by default)

The base app needs no personal account and keeps your journal on your device.
If you choose to subscribe to an optional **Pro** tier (where available),
these additional features may apply:

- **Sign-in:** Google Sign-In is used to identify your subscription. This
  shares your Google account email and basic profile with Firebase
  Authentication.
- **Cloud backup:** while you are signed in as Pro, your dream entries are
  automatically uploaded one-way to Google Cloud Firestore in your private
  user area (`users/{uid}/dreams/`). This is a backup upload only — there is
  no multi-device restore flow in the current version. Signing out stops
  further uploads. Deleting entries or clearing history while signed in also
  removes the corresponding cloud copies (best-effort).
- **Payments:** subscription billing is handled by **RevenueCat** together
  with **Google Play Billing** (Android) or **Stripe** (web). We never see or
  store your card details; those are handled by the payment provider.

If you never sign in or subscribe, none of the Pro features above occur and
the app remains local-first for your journal.

## 3. Third-party processor: Google (Gemini & Firebase)

Dream text is processed by **Google LLC** via the Gemini API, reached through
**Firebase AI Logic**. The app also uses Firebase for anonymous
authentication and App Check, and — for Pro users only — Cloud Firestore.
Google's use of that data is governed by Google's own terms:

- **Gemini API — Terms of Service:**
  https://ai.google.dev/gemini-api/terms
- **Firebase Terms / Data Processing:**
  https://firebase.google.com/terms
- **Google Privacy Policy:**
  https://policies.google.com/privacy

> Paid API tier: the app uses the **paid** Gemini API tier. Under Google's
> paid-services terms, Google does **not** use your prompts or the model's
> responses to improve its products, and they are not used for training.
> Google may still process the content transiently to generate the
> interpretation and for abuse monitoring as described in its terms. As a
> general precaution with any AI service, avoid submitting content you would
> consider highly sensitive or that could identify you.

Your dream text is routed to Google through Firebase AI Logic, authorised by
a Firebase identifier rather than a personal account on the free tier. No
API key is stored in the app. Data is encrypted in transit (TLS / HTTPS) on
its way to Google.

## 4. Data retention

| Data | Retention |
|------|-----------|
| Local journal (Hive) | Until you delete an entry, clear history, or uninstall / clear site data |
| Pro cloud backup (Firestore) | Until you delete the entry, clear history while signed in, or email us to request deletion |
| Anonymous Firebase UID | Until you clear site data, uninstall, or sign in with Google (which replaces the session) |
| Google Gemini processing | Governed by Google's terms; processed transiently to return a result |
| Payment records | Governed by RevenueCat / Google Play / Stripe retention policies |

Cloud backup is **best-effort**. Do not treat it as your only copy of important
data.

## 5. Legal bases (GDPR / UK GDPR / Romanian Law 190/2018)

The developer is based in Romania, so processing complies with the EU GDPR as
implemented in Romania by **Law 190/2018**. Where the GDPR applies, our legal
basis for processing your dream text via Google Gemini is **consent**, which you
give by tapping the Interpret button after reading this policy (linked from
onboarding and Settings). You can withdraw consent at any time by not submitting
further dreams and by clearing your local history.

We do not transfer any data ourselves beyond what Firebase and Google process
under their own data processing terms.

## 6. Children

REMind-Ai is **not intended for users under 18**. The app shows an explicit
age confirmation on first launch. If a person under 18 has used the app,
their guardian can email **liviustefan.petroaia@gmail.com** and we will help
them clear local data and delete any Pro cloud copies associated with their
account.

## 7. Your rights

You have the right to:

- **Access** — your dream content lives on your device. If you are a signed-in
  Pro user, copies also live in your private Firestore area, accessible only
  with your Google account.
- **Erasure** — delete individual entries or use **Settings → Clear dream
  history**. While signed in, this removes matching cloud copies as well
  (best-effort). You can also email us for assistance.
- **Object / withdraw consent** — stop using the Interpret feature.
- **Lodge a complaint** with your local data protection authority (in Romania:
  ANSPDCP — www.dataprotection.ro).

For anything else, email **liviustefan.petroaia@gmail.com**.

## 8. Security

- Local Hive boxes are encrypted with AES-256 using a random key generated
  on first launch and held in platform secure storage.
- All network traffic to Google (Gemini and Firebase) uses HTTPS.
- Interpretation requests carry no embedded API key; they are routed through
  Firebase AI Logic and verified by Firebase App Check.
- The Android build uses Android's network security config to block
  cleartext traffic and disables device/cloud backup of app data.
- The app only contacts Google's Firebase / Gemini endpoints,
  reCAPTCHA (on the Web), payment providers (Pro), and its own self-hosted
  assets.

No system is perfectly secure. Use the app at your own discretion.

## 9. Changes to this policy

We may update this policy. The "Last updated" date at the top reflects the
most recent change. Significant changes will be announced in the app's
release notes.

## 10. Contact

Liviu-Stefan Petroaia — independent developer (no company affiliation)
Email: **liviustefan.petroaia@gmail.com**
