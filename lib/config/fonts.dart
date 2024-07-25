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

  static const settingTitle = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w700,
      fontSize: 20,
      letterSpacing: 1.6,
      color: Colors.black);

  static const settingLabel = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w400,
      fontSize: 16,
      letterSpacing: 1.6,
      color: Colors.black);

  static const settingLabel2 = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 1.6,
      color: Colors.black);

  static const versionLabel = TextStyle(fontFamily: "Pretendard",
      fontWeight: FontWeight.w400,
      fontSize: 14,
      letterSpacing: 1.6,
      color: Color(0xFF666870));

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

  static const createsquadTitle = TextStyle(
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w700,
    fontSize: 18,
    letterSpacing: 1
  );

  static const playerName = TextStyle(
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    fontSize: 12,
    color: Colors.amber,
  );

  static const statemessage = TextStyle(
    fontFamily: "Pretendard",
    fontWeight: FontWeight.w400,
    letterSpacing: 1,
    fontSize: 11,
    color: Colors.red,
  );
}


class Fonts {
  Fonts._();
  static final TextStyle player = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
    color: Colors.amber
  );
}