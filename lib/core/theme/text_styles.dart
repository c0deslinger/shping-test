import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle get headlineSmall =>
      GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w600);

  static TextStyle get titleMedium =>
      GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get titleLarge =>
      GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w600);

  static TextStyle get bodySmall =>
      GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle get bodyMedium =>
      GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400);
}
