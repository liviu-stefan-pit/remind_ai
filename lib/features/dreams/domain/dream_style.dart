import 'package:remind_ai/core/network/gemini_client.dart';

enum DreamStyle { standard, psychological, mythic, creative }

extension DreamStyleX on DreamStyle {
  /// Pro-only styles require an active Pro entitlement to run.
  bool get isPro => this != DreamStyle.standard;

  /// Gemini model that backs this style. Standard uses the fast, low-cost
  /// model; Pro styles use the dedicated Pro model (`kProModel` in
  /// `gemini_client.dart`).
  String get model => isPro ? kProModel : kStandardModel;

  /// Output budget tuned to the prompt's target length. Pro styles produce
  /// longer, richer readings, so they get a larger budget.
  int get maxOutputTokens => isPro ? 1024 : 512;
}
