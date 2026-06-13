abstract final class AppStrings {
  static const String appName = 'REMind-Ai';

  static const String interpretDream = 'Decode This Dream';

  static const String describeDreamLabel =
      'What did your brain cook up last night?';

  static const String describeDreamHint =
      'Spill the subconscious tea... flying, falling, or your teeth again?';

  static const String interpretationStyle = 'How Do You Want to Dig In?';

  static const String interpret = 'Unravel It';

  static const int dreamMaxChars = 2000;

  static const String minCharsError =
      'Your brain works harder than that — give us at least 20 characters.';

  static const String maxCharsError =
      'That is a novel. Keep it under 2000 characters.';

  static const String upgradeToPro = 'Unlock with Pro:';

  static const String dailyLimitReached =
      'Your subconscious needs rest too. Daily interpretations used — see you tomorrow!';

  static const String proRequired =
      'This is a Pro interpretation style. Upgrade to unlock it.';

  static const String proRequiredComingSoon =
      'This is a Pro interpretation style. Pro is coming soon.';

  static const String rateLimited =
      'Easy, dream-chaser. Give it a few seconds before the next reading.';

  static const String unexpectedError =
      'The dream gremlins struck again. Try once more.';

  static const String inputDisclaimer =
      'AI-generated, for entertainment and reflection only — not medical or '
      'psychological advice.';

  static String readingsRemainingToday(int remaining, int limit) =>
      '$remaining of $limit readings left today';

  // Interpretation style descriptions (shown on the style cards).

  static const String styleStandardName = 'Standard';

  static const String styleStandardDesc =
      'Explore possible symbol meanings, straight to the point.';

  static const String stylePsychologicalName = 'Psychological';

  static const String stylePsychologicalDesc =
      'A reflective lens on your inner world — for insight and fun, not therapy.';

  static const String styleMythicName = 'Mythic';

  static const String styleMythicDesc =
      'Your dream read through myth and folklore.';

  static const String styleCreativeName = 'Creative';

  static const String styleCreativeDesc =
      'Reimagined as a short, surreal story or poem.';

  static const String interpretationReady = 'The cosmos have spoken!';

  static const String dreamHistory = 'Past Visions';

  static const String dreamInterpretation = 'What It All Means';

  static const String yourDream = 'The Raw Material';

  static const String interpretation = 'The Cosmic Read';

  static const String noHistoryYet =
      'No visions logged yet. Your subconscious is waiting...';

  static const String historyEmptyCta = 'Decode your first dream';

  static const String copiedToClipboard = 'Copied to clipboard';

  static const String deleteConfirmTitle = 'Erase this vision?';

  static const String deleteConfirmMessage =
      'This dream entry will be removed from this device.';

  static const String deleteConfirmMessageSignedIn =
      'This dream entry will be removed from this device and from your cloud '
      'backup.';

  static const String deleteConfirmCloudWarning =
      'If you previously backed up to the cloud while signed in, sign in again '
      'before deleting to remove cloud copies too.';

  static const String delete = 'Delete';

  static const String cancel = 'Cancel';

  // Home screen

  static const String homeKicker = 'GOOD MORNING';

  static const String homeTagline = 'What did you dream?';

  static const String homeBody =
      'Capture the fragments before they fade. Explore possible meanings with '
      'AI — for fun and reflection, not professional advice.';

  static const String homeCtaHint = 'Your subconscious awaits...';

  // Settings

  static const String settings = 'Settings';

  static const String appearance = 'Appearance';

  static const String theme = 'Theme';

  static const String themeDark = 'Dark';

  static const String themeLight = 'Light';

  static const String themeSystem = 'System';

  static const String reduceMotion = 'Reduce motion';

  static const String reduceMotionHint =
      'Disables sky animation and heavy effects';

  static const String ambientMotion = 'Background motion';

  static const String ambientOff = 'Off';

  static const String ambientCalm = 'Calm';

  static const String ambientLively = 'Lively';

  static const String account = 'Account';

  static const String proActive = 'Pro active';

  static const String proActiveHint = 'All interpretation styles unlocked';

  static const String proUpsellHint =
      'Unlock Psychological, Mythic, and Creative styles';

  // Profile & Pro

  static const String profile = 'Profile';

  static const String insights = 'Insights';

  static const String dreamer = 'Dreamer';

  static const String tierPro = 'PRO';

  static const String tierFree = 'FREE';

  static const String signInWithGoogle = 'Continue with Google';

  static const String signInTagline =
      'Your dream journal, protected. Sign in to start interpreting dreams and keep your limit tied to your account.';

  static const String signInQuotaNotice =
      'Free: 3 readings/day · Pro: 20 readings/day';

  static const String signOut = 'Sign out';

  static const String signInFailed = 'Sign-in failed. Please try again.';

  static const String upgradeCta = 'Upgrade to Pro — \$1.99/month';

  static const String proPitchTitle = 'Go Pro';

  static const String proPitchPrice = '\$1.99 / month';

  static const String proPitchPlannedPrice = 'Planned price: \$1.99 / month';

  static const String proComingSoon = 'Pro is coming soon';

  static const String proComingSoonNotice =
      'Advanced styles, a higher daily reading limit, cloud backup, and the '
      'insights dashboard are on the way. The app is fully usable on the '
      'free tier in the meantime.';

  static const String proComingSoonStyle = 'This Pro style is coming soon.';

  static const String subscriptionFinePrint =
      'Auto-renews monthly until cancelled. Cancel anytime in your billing '
      'portal. See Terms of Service for refund and withdrawal details.';

  static const String renewsOn = 'Renews on';

  static const String manageSubscription = 'Manage subscription';

  static const String manageSubscriptionHint =
      'Cancel or change your subscription anytime through the billing portal.';

  static const String manageUnavailable =
      "Couldn't open subscription management. Please try again later.";

  static const String stillNotPro =
      'No active subscription found yet. Try again in a moment.';

  static const String purchaseNotConfigured =
      'Purchases are not configured for this build.';

  static const String backendNotConfigured =
      'Cloud features are not configured in this build. Sign-in and sync are '
      'unavailable.';

  static const String waitingForPayment =
      'Waiting for your payment to confirm...';

  static const String waitingForPaymentHint =
      'Complete the checkout in your browser, then return here. We will detect '
      'your Pro status automatically.';

  static const String refreshStatus = 'Refresh status';

  static const String data = 'Data';

  static const String clearHistory = 'Clear dream history';

  static const String clearHistoryConfirmTitle = 'Clear all dreams?';

  static const String clearHistoryConfirmMessage =
      'Every saved dream will be permanently removed from this device.';

  static const String clearHistoryConfirmMessageSignedIn =
      'Every saved dream will be removed from this device and from your cloud '
      'backup.';

  static const String historyCleared = 'Dream history cleared';

  static const String about = 'About';

  static const String versionLabel = 'Version 1.0.0';

  static const String markOnboardingSeen = 'Mark onboarding complete';

  static const String onboardingBegin = 'Begin dreaming';

  static const String newDream = 'New dream';

  static const String copy = 'Copy';

  static const String saved = 'Saved';

  // Legal

  static const String legal = 'Legal';

  static const String privacyPolicy = 'Privacy Policy';

  static const String termsOfService = 'Terms of Service';

  static const String ageGateLabel = 'I confirm I am 18 or older';

  static const String ageGateRequired =
      'Confirm you are 18+ to continue. Gemini API terms require it.';

  static const String onboardingLegalNotice =
      'By continuing, you agree to our Terms of Service and Privacy Policy.';

  static const String aiDisclaimer =
      'AI-generated content. For entertainment only. Not medical, '
      'psychological, or professional advice.';

  static const String onboardingPrivacyTitle = 'Your journal, your control';

  static const String onboardingPrivacyBody =
      'Dreams are stored locally on this device in an encrypted journal. When '
      'you request a reading, your dream text is sent to Google Gemini to '
      'generate it. Signing in with Google ties your daily reading limit to '
      'your account. Optional Pro cloud backup is available for Pro subscribers.';
}

abstract final class AppUrls {
  // NOTE: these must be LIVE before any store submission. The privacy/ and

  // terms/ HTML pages are hosted on GitHub Pages at these exact URLs; update

  // them here and in STORE_METADATA.md if the host changes. See Part A of

  // PUBLISH_NEXT_STEPS.md ("Host the privacy policy AND terms of service").

  static const String privacyPolicy =
      'https://liviu-stefan-pit.github.io/remind_ai/privacy/';

  static const String termsOfService =
      'https://liviu-stefan-pit.github.io/remind_ai/terms/';

  static const String contactEmail = 'liviustefan.petroaia@gmail.com';
}
