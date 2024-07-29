import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

Widget animated_text(String text) {
  return Container(
    width: 90,
    child: Marquee(
      text: text,
      velocity: 50.0,
      blankSpace: 50,
      startPadding: 4.0,
      pauseAfterRound: Duration(milliseconds: 2000),
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    ),
  );
}