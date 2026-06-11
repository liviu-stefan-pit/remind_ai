# REMind-Ai — Store Metadata Drafts

Ready-to-paste copy for Google Play, Microsoft Store, and the Vercel web
landing description. Update version numbers and screenshots as you go.

---

## Shared

- **App name:** REMind-Ai
- **Tagline (≤30 chars):** Decode your dreams.
- **Developer / Publisher:** Liviu-Stefan Petroaia (independent)
- **Contact email:** liviustefan.petroaia@gmail.com
- **Category:** Lifestyle (primary) · Health & Fitness (secondary)
- **Content rating target:** 18+ (Gemini API ToS requirement)
- **Privacy Policy URL:** https://liviustefan.github.io/remind-ai/privacy *(replace with final hosted URL)*

---

## Google Play Store

### App name (≤30 chars)
`REMind-Ai — Dream Decoder`

### Short description (≤80 chars)
`AI-powered dream interpretation in four unique styles. Private and on-device.`

### Full description (≤4000 chars)

```
Wake up curious? REMind-Ai is a quiet companion for your subconscious. Type
the dream you can still remember and choose how you want to read it —
Standard, Psychological, Mythic, or Creative — then let an AI walk through
the imagery with you.

WHAT YOU CAN DO
• Write down the fragments while they're fresh.
• Pick one of four interpretation lenses.
• Save every dream and interpretation in a private local journal.
• Browse your history in a calm, focused timeline.

PRIVACY FIRST
• Your dream journal lives only on this device, in an encrypted database.
• No accounts, no email, no advertising IDs, no analytics.
• When you tap Interpret, the text of that one dream is sent securely
  to Google's Gemini AI for processing. Nothing else is shared.
• Clear your full history any time from Settings.

DESIGN
A dark cosmic interface with a living aurora sky. Subtle motion, calm
typography, and a focused layout that gets out of the way of your writing.

LIMITS
• 3 free interpretations per day.
• Standard interpretation style is free for everyone. Psychological,
  Mythic, and Creative styles are reserved for a future Pro tier.

ABOUT
REMind-Ai is built and maintained by Liviu-Stefan Petroaia as an
independent project. Source-available components and the privacy policy
are linked from the Settings screen.

DISCLAIMER
AI-generated content. For entertainment and personal reflection only. Not
medical, psychological, or professional advice. You must be 18 or older
to use the app, in accordance with Google's Gemini API Terms of Service.
```

### Data Safety form — recommended answers

| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | **Yes** |
| Data collected | **App activity → In-app interactions (user submits dream text to AI)** |
| Is the collected data encrypted in transit? | **Yes** |
| Can users request data deletion? | **Yes — Settings → Clear dream history** |
| Is data shared with third parties? | **Yes — Google (Gemini API)** for processing the interpretation |
| Purpose of sharing | App functionality (AI processing) |
| Type of data shared | App activity (user-generated text submitted by user) |
| Is data optional? | **Yes** — users can choose not to request an interpretation |
| Account creation | **None** |
| Data collected automatically | **None** |

### Content rating (IARC)
Answer "no" to all violence/sexual/gambling/drugs/profanity items. Mention
user-generated text content. Target rating: **18+** because Gemini API ToS
requires it (even if IARC suggests a lower rating, set the in-app age gate
which is already implemented).

---

## Microsoft Store (Windows MSIX)

### Reserved name
`REMind-Ai` *(reserve in Partner Center first)*

### Short description (≤1000 chars)
`REMind-Ai is a calm, private dream journal with AI-powered interpretation.
Write the dream while it's still vivid, pick from four reading styles, and
get an interpretation powered by Google Gemini. Your journal stays on your
device — there are no accounts and no advertising.`

### Description (≤10 000 chars)
Use the same body as the Google Play full description.

### Features list (recommended)
- AI dream interpretation (Gemini)
- Four interpretation styles (Standard free; Psychological / Mythic / Creative reserved for Pro)
- Encrypted local journal — no cloud account
- Dark cosmic UI with optional ambient motion
- Full history and one-tap clear

### System requirements
- Windows 10 / 11 (x64)
- Internet connection required for interpretation

### IARC age rating
Set 18+. Justification: integrates third-party AI service whose ToS
requires users to be 18+.

---

## Web (Vercel landing / OpenGraph)

### `<title>` and `og:title`
`REMind-Ai — AI Dream Interpretation`

### `<meta name="description">` and `og:description`
`Decode your dreams with a calm, private AI journal. Four interpretation
styles. Local-first. No accounts.`

### Suggested OG image
Use the master 1024×1024 icon centered on the cosmic background, or a
landscape 1200×630 variant designed in the same palette
(background `#0A0E1A`, accent `#D4B062`).

---

## Assets you still need to produce

| Asset | Spec | Where used |
|---|---|---|
| Hi-res icon | 512 × 512 PNG | Play Store |
| Feature graphic | 1024 × 500 PNG | Play Store |
| Phone screenshots | 2-8, ≥ 1080 × 1920 portrait | Play Store |
| Tablet screenshots (optional) | 7"/10" | Play Store |
| Microsoft Store screenshot | ≥ 1366 × 768 PNG | Microsoft Store |
| Microsoft Store tile | 300 × 300 PNG | Microsoft Store |
| OG image | 1200 × 630 PNG | Web |

Recommended screenshot route: capture on the Android emulator at
`Pixel 7 Pro` API 35 and on the Windows desktop window for the MS Store.
