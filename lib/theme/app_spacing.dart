import 'package:flutter/material.dart';

/// Screen-relative sizing helpers.
///
/// Every value here is **derived from the live [MediaQuery]** (screen width /
/// height), so the UI scales proportionally across small phones and large
/// tablets. Call sites never use absolute pixel constants — they only use these
/// semantic tokens.
///
/// [_anchorWidth] is the logical width the current design was tuned against; it
/// is used purely as the scaling anchor (so a standard phone looks exactly as
/// designed) — all returned values still come from the device's real size.
class AppSpacing {
  const AppSpacing._();

  static const double _anchorWidth = 390;

  static double _w(BuildContext c) => MediaQuery.sizeOf(c).width;
  static double _h(BuildContext c) => MediaQuery.sizeOf(c).height;

  /// Width ratio relative to the design anchor, clamped to keep extremes sane.
  static double scale(BuildContext c) => (_w(c) / _anchorWidth).clamp(0.82, 1.5);

  // ---- Spacing tokens (scale with screen width) ----
  static double hair(BuildContext c) => 4 * scale(c);
  static double tiny(BuildContext c) => 6 * scale(c);
  static double xxs(BuildContext c) => 8 * scale(c);
  static double xs(BuildContext c) => 10 * scale(c);
  static double sm(BuildContext c) => 12 * scale(c);
  static double md(BuildContext c) => 16 * scale(c);
  static double lg(BuildContext c) => 20 * scale(c);
  static double xl(BuildContext c) => 24 * scale(c);
  static double xxl(BuildContext c) => 40 * scale(c);

  // ---- Component sizing (fractions of the screen, no absolute pixels) ----

  /// Flag width in list cards.
  static double flagWidth(BuildContext c) => _w(c) * 0.22; // Increased from 0.155

  /// Flag width-to-height ratio used for list-card flags.
  static const double flagAspectRatio = 1.3; // Slightly more squarish to fill better

  /// Flag banner height in the compare screen headers.
  static double flagBannerHeight(BuildContext c) => _w(c) * 0.155;

  /// Hero flag banner height on the country-details screen.
  static double heroFlagHeight(BuildContext c) => _h(c) * 0.18;

  /// Vertical gap used by empty-state placeholders.
  static double emptyStateGap(BuildContext c) => _h(c) * 0.08;

  /// Target height for an info-grid cell (keeps text fitting on any width).
  static double infoCellHeight(BuildContext c) => _w(c) * 0.18;
}
