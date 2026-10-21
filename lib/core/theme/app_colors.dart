import 'package:flutter/material.dart';

/// ADMS Electric Mobility — Design Token: Colours
/// All colour decisions are made here. Never hard-code colour values elsewhere.
abstract class AppColors {
  // ── Background ─────────────────────────────────────────────────────────────
  static const Color backgroundPrimary = Color(0xFF0B0D0F);
  static const Color backgroundSecondary = Color(0xFF111417);
  static const Color backgroundCard = Color(0xFF161A1F);
  static const Color backgroundElevated = Color(0xFF1C2027);
  static const Color backgroundOverlay = Color(0x99000000);

  // ── Accent ─────────────────────────────────────────────────────────────────
  static const Color accentLime = Color(0xFFD8FF25);
  static const Color accentLimeDark = Color(0xFFB8D900);
  static const Color accentLimeGlow = Color(0x40D8FF25);
  static const Color accentLimeSurface = Color(0x1AD8FF25);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFADB5BD);
  static const Color textMuted = Color(0xFF6C757D);
  static const Color textDisabled = Color(0xFF495057);
  static const Color textInverse = Color(0xFF0B0D0F);

  // ── Borders ────────────────────────────────────────────────────────────────
  static const Color borderSubtle = Color(0xFF1E2329);
  static const Color borderMedium = Color(0xFF2A3040);
  static const Color borderStrong = Color(0xFF3D4759);
  static const Color borderAccent = Color(0x60D8FF25);

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color statusSuccess = Color(0xFF28A745);
  static const Color statusWarning = Color(0xFFFFC107);
  static const Color statusError = Color(0xFFDC3545);
  static const Color statusInfo = Color(0xFF17A2B8);

  // ── Scooter Colour Swatches ─────────────────────────────────────────────────
  static const Color swatchPearlWhite = Color(0xFFF5F5F5);
  static const Color swatchMatteBlack = Color(0xFF1A1A1A);
  static const Color swatchMetallicRed = Color(0xFFB22222);
  static const Color swatchBlue = Color(0xFF1565C0);
  static const Color swatchGrey = Color(0xFF607D8B);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B0D0F), Color(0xFF111417), Color(0xFF0B0D0F)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFD8FF25), Color(0xFF9ECB00)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C2027), Color(0xFF161A1F)],
  );

  static const LinearGradient darkFadeBottom = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xDD0B0D0F)],
  );
}
