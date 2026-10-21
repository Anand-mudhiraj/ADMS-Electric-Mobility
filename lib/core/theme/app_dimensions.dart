import 'package:flutter/material.dart';

/// ADMS Electric Mobility — Spacing, Radius, Shadow tokens
abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Page horizontal padding
  static const double pagePaddingMobile = 20.0;
  static const double pagePaddingTablet = 40.0;
  static const double pagePaddingDesktop = 80.0;

  // Card internal padding
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(12.0);
}

abstract class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 999.0;

  static const BorderRadius xsBorderRadius =
      BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smBorderRadius =
      BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdBorderRadius =
      BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgBorderRadius =
      BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlBorderRadius =
      BorderRadius.all(Radius.circular(xl));
}

abstract class AppShadows {
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static const BoxShadow accentGlow = BoxShadow(
    color: Color(0x40D8FF25),
    blurRadius: 20,
    spreadRadius: 0,
  );

  static const BoxShadow subtleGlow = BoxShadow(
    color: Color(0x20D8FF25),
    blurRadius: 40,
    spreadRadius: 5,
  );

  static const BoxShadow elevatedShadow = BoxShadow(
    color: Color(0x60000000),
    blurRadius: 40,
    offset: Offset(0, 16),
  );
}
