import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:remind_ai/constants/app_strings.dart';

import 'helpers/test_harness.dart';

part 'onboarding_flow.dart';
part 'dream_flow.dart';
part 'navigation.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await initHiveForTests();
    await resetHiveBoxes();
  });

  tearDownAll(() async {
    await disposeHiveForTests();
  });

  onboardingFlowTests();
  dreamFlowTests();
  navigationTests();
}
