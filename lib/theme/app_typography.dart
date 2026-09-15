import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central application typography.
///
/// Latin text uses **Inter**; Persian/Arabic glyphs automatically fall back to
/// **Vazirmatn** at the *glyph* level, so mixed strings such as
/// `"Iran (جمهوری اسلامی)"` render correctly without any per-widget direction
/// logic.
///
/// Sizes are inherited from Flutter's Material 3 [TextTheme] defaults, so there
/// are no arbitrary pixel literals here. Flutter's automatic `MediaQuery` text
/// scaling (accessibility / larger screens) keeps applying on top.
class AppTypography {
  const AppTypography._();

  /// Builds the app [TextTheme] from a Material 3 [base] theme.
  static TextTheme build(TextTheme base) {
    // Calling Vazirmatn once registers + starts loading the font, and gives us
    // the registered family name to use as a glyph fallback. (A hardcoded
    // 'Vazirmatn' string would NOT resolve, because google_fonts registers
    // fonts under a `family_variant` name, e.g. 'Vazirmatn_regular'.)
    final String? vazirFamily = GoogleFonts.vazirmatn().fontFamily;

    // Latin base theme.
    final TextTheme inter = GoogleFonts.interTextTheme(base);

    TextStyle? role(
      TextStyle? style, {
      FontWeight? fontWeight,
      double? height,
      double? letterSpacing,
    }) {
      if (style == null) return null;
      return style.copyWith(
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        fontFamilyFallback: <String>[
          ...?style.fontFamilyFallback,
          if (vazirFamily != null) vazirFamily,
        ],
      );
    }

    return inter.copyWith(
      // Heading — country name, hero titles.
      headlineMedium: role(inter.headlineMedium, fontWeight: FontWeight.w700, letterSpacing: -0.3),
      headlineSmall: role(inter.headlineSmall, fontWeight: FontWeight.w700, letterSpacing: -0.2),

      // Section title — "General Information", card titles.
      titleMedium: role(inter.titleMedium, fontWeight: FontWeight.w600),
      titleSmall: role(inter.titleSmall, fontWeight: FontWeight.w600),

      // Body — paragraphs, detailed content.
      bodyLarge: role(inter.bodyLarge, height: 1.5),
      bodyMedium: role(inter.bodyMedium, height: 1.6),
      bodySmall: role(inter.bodySmall, height: 1.4),

      // Label — small muted captions under icons ("Capital", "Population").
      labelMedium: role(inter.labelMedium, fontWeight: FontWeight.w500),
      labelSmall: role(inter.labelSmall, fontWeight: FontWeight.w500),
    );
  }
}
