import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography scale: Inter for UI/body, Fraunces serif for display/brand.
abstract final class AppTypography {
  static TextTheme textTheme(Brightness brightness) {
    final base = brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final body = GoogleFonts.interTextTheme(base);
    return body.copyWith(
      displayLarge: GoogleFonts.fraunces(
        textStyle: body.displayLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.fraunces(
        textStyle: body.displayMedium,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      ),
      displaySmall: GoogleFonts.fraunces(
        textStyle: body.displaySmall,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      headlineLarge: GoogleFonts.fraunces(
        textStyle: body.headlineLarge,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      headlineMedium: GoogleFonts.fraunces(
        textStyle: body.headlineMedium,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      headlineSmall: GoogleFonts.fraunces(
        textStyle: body.headlineSmall,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
    );
  }

  static TextStyle brandStyle(Color color, {double size = 22}) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle serifBody(Color color, {double size = 17, double height = 1.55}) =>
      GoogleFonts.fraunces(
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: height,
        color: color,
      );

  static TextStyle sectionLabel(Color color) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        color: color,
      );
}
