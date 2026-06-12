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
  static const String rateLimited =
      'Easy, dream-chaser. Give it a few seconds before the next reading.';
  static const String unexpectedError =
      'The dream gremlins struck again. Try once more.';

  // Interpretation style descriptions (shown on the style cards).
  static const String styleStandardName = 'Standard';
  static const String styleStandardDesc =
      'Clear symbol meanings, straight to the point.';
  static const String stylePsychologicalName = 'Psychological';
  static const String stylePsychologicalDesc =
      'What your dream reveals about your inner life.';
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
      'This dream entry will vanish from your device forever. Poof.';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';

  // Home screen
  static const String homeKicker = 'GOOD MORNING';
  static const String homeTagline = 'What did you dream?';
  static const String homeBody =
      'Capture the fragments before they fade. Let us help you read what your mind was telling you.';
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
  static const String signInWithGoogle = 'Sign in with Google';
  static const String signOut = 'Sign out';
  static const String signInFailed =
      'Sign-in failed. Please try again.';
  static const String upgradeCta = 'Upgrade to Pro — \$1.99/month';
  static const String proPitchTitle = 'Go Pro';
  static const String proPitchPrice = '\$1.99 / month';
  static const String renewsOn = 'Renews on';
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
  static const String historyCleared = 'Dream history cleared';
  static const String about = 'About';
  static const String versionLabel = 'Version 1.0.0';
  static const String markOnboardingSeen = 'Mark onboarding complete';
  static const String onboardingBegin = 'Begin dreaming';
  static const String newDream = 'New dream';
  static const String share = 'Share';
  static const String saved = 'Saved';

  // Legal
  static const String legal = 'Legal';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsOfService = 'Terms of Service';
  static const String ageGateLabel = 'I confirm I am 18 or older';
  static const String ageGateRequired =
      'Confirm you are 18+ to continue. Gemini API terms require it.';
  static const String aiDisclaimer =
      'AI-generated content. For entertainment only. Not medical, '
      'psychological, or professional advice.';
  static const String onboardingPrivacyTitle =
      'Your journal lives on this device';
  static const String onboardingPrivacyBody =
      'Your dreams are saved only on this device. When you request an '
      'interpretation, your dream text is sent securely to Google Gemini AI. '
      'It is not stored by us.';
}

abstract final class AppUrls {
  // NOTE: these must be LIVE before any store submission. Host PRIVACY_POLICY.md
  // (e.g. GitHub Pages / Vercel static page) at these exact URLs, or update
  // them here and in STORE_METADATA.md. See PUBLISH_NEXT_STEPS.md step 3.
  static const String privacyPolicy =
      'https://liviu-stefan-pit.github.io/remind_ai/privacy/';
  static const String termsOfService =
      'https://liviu-stefan-pit.github.io/remind_ai/terms/';
  static const String contactEmail = 'liviustefan.petroaia@gmail.com';
}

