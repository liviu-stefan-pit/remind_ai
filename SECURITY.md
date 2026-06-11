# REMind-Ai — Security notes

## Threat model summary

REMind-Ai is a client-only app (Android, Web, Windows) that calls the Google
Gemini API directly and stores dream entries locally. There is no app backend
and no user accounts.

## What is already in place

- **Encryption at rest**: both Hive boxes (`prefs`, `dreams`) are AES-256
  encrypted; the key is generated with `Random.secure()` and stored in
  `flutter_secure_storage` (`lib/hive/hive.dart`).
- **HTTPS only**: the Gemini endpoint is hardcoded HTTPS; Android blocks
  cleartext traffic (`network_security_config.xml`).
- **Android hardening**: `allowBackup=false`, `fullBackupContent=false`, data
  extraction rules exclude all domains, R8 + resource shrinking on release.
- **No data-leaking logs**: Dio has no log interceptor; server error bodies are
  only printed in debug; `debugPrint` is silenced in release.
- **No HTML/markdown rendering** of model output, so no web XSS surface.
- **Web security headers**: CSP, `X-Frame-Options`, `nosniff`,
  `Referrer-Policy`, `Permissions-Policy` set in `vercel.json`.
- **Prompt-injection guard + safety settings**: user dream text is wrapped in
  `<dream>…</dream>` and the system instruction tells the model to treat it as
  data; lenient `safetySettings` block only egregious content
  (`lib/core/network/gemini_client.dart`).

## Known accepted risk: client-side API key

The Gemini key is injected at build time via `--dart-define` and therefore
ships inside every release artifact (Web `main.dart.js`, Android `libapp.so`,
the Windows binary). It is **extractable**. Mitigations applied today:

- API key restrictions in Google Cloud (HTTP referrer for Web, Android package
  + signing-cert for Play, API restricted to the Generative Language API).
- Per-key quotas and a billing budget alert.
- Client-side daily free-request limit (defense against casual overuse only;
  trivially bypassable by clearing local storage).

## Durable fix (recommended before/at public Web launch): backend proxy

Replace the direct client→Gemini call with a thin proxy that holds the key
server-side:

```
App  ──HTTPS──▶  Proxy (Vercel Edge Function / Cloud Function)  ──▶  Gemini
                  - holds GEMINI_API_KEY (never sent to client)
                  - enforces server-side rate limiting (per IP / token)
                  - validates input length and content
                  - returns only the interpretation text
```

Implementation outline:

1. Add an endpoint (e.g. `/api/interpret`) that accepts `{ dreamText, style }`.
2. Move the request body assembly (system instruction, `<dream>` wrapping,
   `safetySettings`, `generationConfig`) from `gemini_client.dart` to the proxy.
3. Point `GeminiClient` at the proxy URL; drop the `x-goog-api-key` header from
   the client entirely.
4. Keep the client-side daily limit as UX, but enforce the real limit in the
   proxy.

This removes the key from all client binaries and gives a single place to add
abuse controls.

## Reporting

Security issues: contact the maintainer at the email in
`lib/constants/app_strings.dart` (`AppUrls.contactEmail`).
