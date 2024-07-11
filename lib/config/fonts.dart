import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class Fonts {
  Fonts._();

  static final TextStyle largeTitle = GoogleFonts.roboto(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
      color: Colors.black
  );

  static final TextStyle title = GoogleFonts.roboto(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
      color: Colors.black
  );

  static final TextStyle subtitle = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
  );

  static final TextStyle subtitle2 = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
  );

  static final TextStyle parag1 = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
  );

  static final TextStyle parag2 = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
  );

  static final TextStyle parag3 = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
  );

  static final TextStyle parag4 = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
  );

  static final TextStyle label = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
  );
}