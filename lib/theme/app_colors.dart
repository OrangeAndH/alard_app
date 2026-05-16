import 'package:flutter/material.dart';

/// Central color palette for the Alard app.
/// All screens must reference these constants instead of redeclaring them inline.
/// Estimated lines: ~45
class AppColors {
  AppColors._();

  // ── Core Brand ──────────────────────────────────────────────────
  /// Primary olive-green used for text, icons, and buttons.
  static const Color olive = Color(0xFF55682A);

  /// Lighter olive used in dark-mode accents and gradient highlights.
  static const Color oliveLight = Color(0xFF7A8D2F);

  /// Deep olive used for button backgrounds on login/register screens.
  static const Color oliveDark = Color(0xFF3E460E);

  /// Gold accent for best-seller badges, stars, and hero CTAs.
  static const Color gold = Color(0xFFE0A323);

  /// Muted gold used on location highlight bar.
  static const Color locationGreen = Color(0xFFA5BA1E);

  // ── Backgrounds ──────────────────────────────────────────────────
  /// Main scaffold background — warm off-white.
  static const Color background = Color(0xFFF7F3EE);

  /// Card / input field fill — slightly darker cream.
  static const Color cream = Color(0xFFF2EDE6);

  /// Soft button background for quantity controls.
  static const Color softButton = Color(0xFFF4ECD9);

  /// Why-Alard section background.
  static const Color whyFrameBackground = Color(0xFFF1E9DE);

  // ── Lines & Borders ──────────────────────────────────────────────
  /// Divider / border color throughout checkout screens.
  static const Color line = Color(0xFFE3DACE);

  /// Soft border used in checkout item cards.
  static const Color softBorder = Color(0xFFE6DED2);

  /// Checkout box border (slightly darker than `line`).
  static const Color checkoutBorder = Color(0xFF6B7A35);

  // ── Text / UI ────────────────────────────────────────────────────
  /// Dark navy used for menu icon on home screen.
  static const Color darkBlue = Color(0xFF0E1A39);

  // ── Dark Mode ────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkNavBar = Color(0xFF1E1E1E);
}
