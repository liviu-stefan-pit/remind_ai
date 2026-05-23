import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  double get _screenWidth => MediaQuery.sizeOf(this).width;

  bool get isMobile => _screenWidth < 600;
  bool get isTablet => _screenWidth >= 600 && _screenWidth < 1024;
  bool get isDesktop => _screenWidth >= 1024;

  double get maxContentWidth =>
      isDesktop ? 720 : (isTablet ? 640 : double.infinity);

  EdgeInsets get contentPadding =>
      EdgeInsets.symmetric(horizontal: isDesktop ? 40 : (isTablet ? 32 : 20));
}
