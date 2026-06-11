# REMind-Ai — Publish Next Steps (manual)

Everything in [PUBLISH_CHECKLIST.md](../PUBLISH_CHECKLIST.md) that the
agent could automate is done. The remaining items below require **your**
accounts, secrets, or wallet and cannot be performed inside this repo.

> Treat this file as your runbook. Tick items off as you go.

---

## 1. Gemini API key rotation

> SECURITY: A previous key was once written into this file. It must be
> treated as compromised. Revoke it and never paste a live key into any
> committed file again (use a placeholder like `<YOUR_GEMINI_KEY>`).

- [ ] In Google Cloud Console, **revoke** the previously exposed key
      (the one that used to appear in this file's git history).
- [ ] Generate a new Gemini API key.
- [ ] Apply key restrictions as defense-in-depth: HTTP-referrer
      restriction for the Web build, Android app (package name + SHA-1
      signing cert) restriction for the Play build, and API restriction
      to the Generative Language API only.
- [ ] Set per-key quotas and a billing budget alert in Google Cloud.
- [ ] Store it locally in `.vscode/launch.json` (gitignored) and in your
      password manager. Never paste it into a committed file.
- [ ] Once Production is ready, paste it as the `GEMINI_API_KEY`
      environment variable in Vercel (Production + Preview scopes).

> NOTE: client-side `--dart-define` keys are extractable from every
> release artifact (Web JS, Android `libapp.so`, Windows binary). Key
> restrictions reduce abuse but do not hide the key. See the backend
> proxy recommendation in `SECURITY.md` for the durable fix.

## 2. Switch to paid Gemini tier

- [ ] Enable billing on the Google Cloud project that owns the new key.
- [ ] Pick the `gemini-2.5-flash-lite` model on the paid tier.
- [ ] After the switch, edit `PRIVACY_POLICY.md` and remove the
      *"Free-tier disclosure"* block (Google no longer uses prompts for
      training on the paid tier).

## 3. Privacy policy hosting

- [ ] Create a public host for `PRIVACY_POLICY.md` (GitHub Pages on a
      `remind-ai` repo, or a separate Vercel static site).
- [ ] Update `AppUrls.privacyPolicy` and `AppUrls.termsOfService` in
      `lib/constants/app_strings.dart` to point at the live URL.
- [ ] Update `STORE_METADATA.md` with the same URL.

## 4. Android release signing

- [ ] From `remind_ai/android/`, run:
      ```powershell
      keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 `
              -validity 10000 -alias remindai
      ```
- [ ] Copy `android/key.properties.example` to `android/key.properties`
      and fill in the four real values.
- [ ] **Back up `key.jks` and the passwords** to at least two secure
      locations (e.g. password manager + offline encrypted drive).
      Losing this file means you can never update the app on Play.
- [ ] Build the App Bundle:
      ```powershell
      Push-Location c:\prod\FlutterAI\remind_ai
      flutter build appbundle --release --dart-define=GEMINI_API_KEY=<key>
      Pop-Location
      ```

## 5. Replace placeholder icon with real artwork

- The current `assets/icon/icon.png` and `icon_foreground.png` are
  AI-generated placeholders. Replace them with **original artwork** you
  own before submitting to either store.
- After replacing, re-run:
  ```powershell
  Push-Location c:\prod\FlutterAI\remind_ai
  dart run flutter_launcher_icons
  Pop-Location
  ```

## 6. Vercel deployment (Web)

- [ ] Sign up at vercel.com.
- [ ] Import the GitHub repo.
- [ ] In project settings:
  - Framework Preset: **Other**
  - Root Directory: `remind_ai`
  - Build/Output: leave to `vercel.json`
- [ ] Environment Variables → add `GEMINI_API_KEY` (Production + Preview).
- [ ] Trigger a deploy; verify SPA routing works by navigating directly
      to `/home` and `/onboarding` and hitting refresh.
- [ ] Add a custom domain when ready.

## 7. Microsoft Store

- [ ] Register a Microsoft Partner Center account ($19 one-time).
- [ ] Reserve the name **REMind-Ai** in Partner Center *before*
      generating the MSIX.
- [ ] Update `msix_config.publisher` in `pubspec.yaml` with the
      Publisher Identity string shown in Partner Center after the
      reservation (`CN=…`). Then build:
      ```powershell
      Push-Location c:\prod\FlutterAI\remind_ai
      flutter build windows --release --dart-define=GEMINI_API_KEY=<key>
      dart run msix:create
      Pop-Location
      ```
- [ ] Upload the resulting `.msix` from `build/windows/x64/runner/Release/`
      to Partner Center.
- [ ] Complete the IARC questionnaire (target rating 18+).
- [ ] Paste the description from `STORE_METADATA.md`.

## 8. Google Play

- [ ] Register a Google Play Developer account ($25 one-time, requires ID).
- [ ] Create a new app, paste copy from `STORE_METADATA.md`.
- [ ] Upload App Bundle from step 4.
- [ ] Complete the Data Safety form using the answers in
      `STORE_METADATA.md`.
- [ ] Complete the IARC questionnaire.
- [ ] Upload the assets listed at the bottom of `STORE_METADATA.md`.

## 9. Screenshots & marketing assets

- [ ] Phone screenshots — run on an emulator (Pixel 7 Pro API 35), capture
      Home, Dream Input, Result, History, Settings.
- [ ] Tablet screenshots (optional).
- [ ] Microsoft Store screenshot — capture the Windows desktop window at
      1366 × 768 or higher.
- [ ] Feature graphic 1024 × 500.

## 10. Final smoke test before each submission

- [ ] `flutter analyze` clean.
- [ ] Dream submission works end-to-end (network reachable).
- [ ] Daily-limit message appears after 3 free requests.
- [ ] Settings → Clear history empties the journal.
- [ ] Privacy Policy and Terms tiles open the live URL.
- [ ] Age-gate checkbox must be ticked before the onboarding CTA
      activates on the last page.
- [ ] First launch on a fresh device shows the encrypted Hive boxes
      open successfully (no "key not found" errors in logs).
