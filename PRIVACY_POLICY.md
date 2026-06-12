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

This policy applies to everyone who uses REMind-Ai on Android, Windows, or
the Web. You must be **18 years or older** to use the app — this is required
by Google's Gemini API Terms of Service, which power the interpretation
feature.

## 2. What data the app handles

REMind-Ai does **not** require an account, email, password, phone number,
or any registration. We do **not** collect analytics, advertising IDs,
device identifiers, location, contacts, camera, microphone, or any
behavioural telemetry.

The only personal content the app handles is the text **you** type into the
dream input field, plus the AI-generated interpretation returned for that
text.

### Data stored on your device

- Your dream entries and their interpretations
- App preferences (theme, motion, onboarding state, age confirmation)

This data is stored locally on your device in an encrypted Hive database.
The encryption key is held in the platform secure storage
(Android Keystore / Windows DPAPI / browser-local storage on Web). The
developer cannot read your local database.

You can wipe all locally stored data at any time through
**Settings → Clear dream history**, or by uninstalling the app / clearing
site data on the Web build.

### Data sent off-device

When you tap **Unravel It** (the "Interpret" action), the text of the
specific dream you submitted is sent over HTTPS to Google's Gemini API
(`generativelanguage.googleapis.com`) so the AI model can produce an
interpretation. Only the dream text and the prompt parameters are sent.
The interpretation returned by Google is shown to you and stored locally.

We do not send your dream text to any other service. The developer does
**not** receive, see, or store your dream text.

### Optional Pro tier (off by default)

The base app needs no account and keeps everything on your device. If you
choose to subscribe to an optional **Pro** tier (where available), these
additional, opt-in features may apply:

- **Sign-in:** Google Sign-In is used to identify your subscription. This
  shares your Google account email and basic profile with the app's backend
  provider.
- **Cloud backup:** your dream entries may be backed up to Google Cloud
  Firestore so they sync across your devices. This is only enabled for
  signed-in Pro users and can be turned off by signing out.
- **Payments:** subscription billing is handled by **RevenueCat** together
  with **Google Play Billing** (Android) or **Stripe** (web). We never see or
  store your card details; those are handled by the payment provider.

If you never sign in or subscribe, none of the above occurs and the app
remains fully local.

## 3. Third-party processor: Google Gemini

Dream text is processed by **Google LLC** via the Gemini API. Google's use
of that data is governed by Google's own terms:

- **Gemini API — Terms of Service:**
  https://ai.google.dev/gemini-api/terms
- **Google Privacy Policy:**
  https://policies.google.com/privacy

> Paid API tier: the app uses the **paid** Gemini API tier. Under Google's
> paid-services terms, Google does **not** use your prompts or the model's
> responses to improve its products, and they are not used for training.
> Google may still process the content transiently to generate the
> interpretation and for abuse monitoring as described in its terms. As a
> general precaution with any AI service, avoid submitting content you would
> consider highly sensitive or that could identify you.

Your dream text is sent to Google with an anonymous API key. It is not tied
to your name, an account, or a device identifier on our side. Data is
encrypted in transit (TLS / HTTPS) on its way to Google.

## 4. Legal bases (GDPR / UK GDPR / Romanian Law 190/2018)

The developer is based in Romania, so processing complies with the EU GDPR as
implemented in Romania by **Law 190/2018**. Where the GDPR applies, our legal
basis for processing your dream text via Google Gemini is **consent**, which you
give by tapping the Interpret button after reading this policy. You can withdraw
consent at any time by not submitting further dreams and by clearing your local
history.

We do not transfer any data ourselves — Google Gemini handles its own
international transfers under Google's data processing terms.

## 5. Children

REMind-Ai is **not intended for users under 18**. The app shows an explicit
age confirmation on first launch. If a person under 18 has used the app,
their guardian can email **liviustefan.petroaia@gmail.com** and we will
help them clear local data and remove any record we may hold (which, in
practice, is none — we do not store user content).

## 6. Your rights

You have the right to:

- Access — but there is nothing on our side to access; your content lives
  only on your device.
- Erasure — use **Settings → Clear dream history**, or uninstall.
- Object / withdraw consent — stop using the Interpret feature.
- Lodge a complaint with your local data protection authority.

For anything else, email **liviustefan.petroaia@gmail.com**.

## 7. Security

- Local Hive boxes are encrypted with AES-256 using a random key generated
  on first launch and held in platform secure storage.
- All network traffic to Google Gemini uses HTTPS.
- The Android build uses Android's network security config to block
  cleartext traffic and disables device/cloud backup of app data.
- The web build is delivered with a strict Content-Security-Policy that
  only permits requests to the Gemini endpoint and self-hosted assets.

## 8. Changes to this policy

We may update this policy. The "Last updated" date at the top reflects the
most recent change. Significant changes will be announced in the app's
release notes.

## 9. Contact

Liviu-Stefan Petroaia — independent developer (no company affiliation)
Email: **liviustefan.petroaia@gmail.com**
