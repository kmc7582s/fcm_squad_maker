import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const String field = "assets/images/field.png";
const String logo = 'assets/images/test_logo.png';

class IconSrc {
  IconSrc._();

  static const IconData search = Icons.search;
  static const IconData download = Icons.download;
  static const IconData delete = Icons.delete;
  static const IconData add = Icons.add;
  static const IconData back = Icons.arrow_back;
  static const IconData cancel = Icons.close;

  //custom_icon
  static const _kFontFam = 'Custom_Icons';
  static const String? _kFontPkg = null;

  static const IconData versus = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bell_alt = IconData(0xf0f3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shoe_prints = IconData(0xea98, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
