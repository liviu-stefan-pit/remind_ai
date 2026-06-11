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
      'Your subconscious needs rest too. 3 daily interpretations used — see you tomorrow!';
  static const String unexpectedError =
      'The dream gremlins struck again. Try once more.';
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
  static const String sourceCode = 'Source Code';
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
      'https://liviustefan.github.io/remind-ai/privacy';
  static const String termsOfService =
      'https://liviustefan.github.io/remind-ai/terms';
  static const String sourceCode = 'https://github.com/liviustefan/remind-ai';
  static const String contactEmail = 'liviustefan.petroaia@gmail.com';
}

