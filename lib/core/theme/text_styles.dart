import 'package:flutter/material.dart';

class AppTextStyle {
  static TextStyle get headlineSmall => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );

  static TextStyle get titleMedium => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      );

  static TextStyle get titleLarge => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );

  static TextStyle get bodySmall => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Colors.black54,
      );

  static TextStyle get bodyMedium => const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      );

  // For dark mode text styles
  static TextStyle get headlineSmallDark =>
      headlineSmall.copyWith(color: Colors.white);
  static TextStyle get titleMediumDark =>
      titleMedium.copyWith(color: Colors.white70);
  static TextStyle get titleLargeDark =>
      titleLarge.copyWith(color: Colors.white);
  static TextStyle get bodySmallDark =>
      bodySmall.copyWith(color: Colors.white54);
  static TextStyle get bodyMediumDark =>
      bodyMedium.copyWith(color: Colors.white70);
}
