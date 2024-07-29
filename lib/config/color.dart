import 'dart:ui';

class Palette {
  Palette._();

  static const Color fwColor = Color(0xFFFF0000);
  static const Color mfColor = Color(0xFF2DB400);
  static const Color dfColor = Color(0xFF0000FF);
  static const Color gkColor = Color(0xFFFFD400);

  static const Color base1 = Color(0xFF000000);
  static const Color base2 = Color(0xFF7C7C7C);
  static const Color basepl = Color(0xff7c7c7cff);
  static const Color base3 = Color(0xFF8B8B8B);
  static const Color base4 = Color(0xFF9D9D9D);
  static const Color base5 = Color(0xFFA4A4A4);
  static const Color base6 = Color(0xFFFFFFFF);

  static const Color main1 = Color(0xFF1A6DFF);

  static const Color error = Color(0xFFD80000);

}

List<String> fw = ['ST','LW','RW','LF','RF','CF'];
List<String> mf = ['CAM','LM','CM','RM','CDM'];
List<String> df = ['LWB','LB','CB','RB','RWB'];
List<String> gk = ['GK'];

Color positionColor(String position) {
  if (fw.contains(position)) {
    return Palette.fwColor;
  } else if (mf.contains(position)){
    return Palette.mfColor;
  } else if (df.contains(position)) {
    return Palette.dfColor;
  } else if (gk.contains(position)) {
    return Palette.gkColor;
  } else {
    return Palette.base1;
  }
}
