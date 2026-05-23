import 'package:flutter/material.dart';

import 'package:remind_ai/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text(AppStrings.appName)));
}
