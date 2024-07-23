import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class CustomTextStyle {
  static const squadTitle = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w300,
      fontSize: 20,
      color: Colors.black);

  static const appbarTitle = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w400,
      fontSize: 24,
      color: Colors.black);

  static const label = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w700,
      fontSize: 24,
      letterSpacing: 1.6,
      color: Colors.black);

  static const sublabel = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w400,
      fontSize: 12,
      letterSpacing: 1,
      color: Colors.blue);

  static const loginTitle = TextStyle(
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w600,
    fontSize: 48,
    color: Color(0xFF666870));

  static const playersTitle = TextStyle(
      fontFamily: "Pretendard",
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: 1,
      color: Colors.black
  );

  static const playerTitle = TextStyle(
      fontFamily: "Pretendard",
      fontWeight: FontWeight.w700,
      fontSize: 20,
      letterSpacing: 1,
      color: Colors.black
  );

  static const gradeTitle = TextStyle(
      fontFamily: "Pretendard",
      fontWeight: FontWeight.w400,
      fontSize: 10,
  );

  static const statLabel = TextStyle(
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w500,
    fontSize: 15,
  );

}


class Fonts {
  Fonts._();

  static final TextStyle test = GoogleFonts.rubik(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
      color: Colors.black
  );

  static final TextStyle subtitle2 = GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
  );

  static final TextStyle player = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
    color: Colors.amber
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
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
  );
}