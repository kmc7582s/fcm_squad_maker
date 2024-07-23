import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:flutter/material.dart';

Widget textField(String hint, TextEditingController controller, bool isId) {
  return TextField(
    controller: controller,
    obscureText: isId,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Palette.base3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Palette.base1),
      ),
    ),
  );
}

