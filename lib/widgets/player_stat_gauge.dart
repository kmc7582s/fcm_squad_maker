import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:flutter/material.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class PlayerStatGauge extends StatefulWidget {
  final int stat;

  const PlayerStatGauge({required this.stat, Key? key}) : super(key: key);

  @override
  State<PlayerStatGauge> createState() => _PlayerStatGaugeState(stat: stat);
}

class _PlayerStatGaugeState extends State<PlayerStatGauge> {
  final int stat;

  _PlayerStatGaugeState({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          child: AnimatedRadialGauge(
            builder: (context, child, value) => RadialGaugeLabel(
              value: stat.toDouble(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
            duration: Duration(milliseconds: 700),
            radius: 100,
            value: stat.toDouble(),
            alignment: Alignment.center,
            axis: GaugeAxis(
              min: 0,
              max: 250,
              degrees: 240,
              style: GaugeAxisStyle(
                thickness: 12,
                segmentSpacing: 2,
              ),
              progressBar: GaugeProgressBar.rounded(
                color: Colors.blue,
              ),
              pointer: GaugePointer.triangle(
                width: 10,
                height: 14,
                borderRadius: 1,
                color: Color(0xFF193663),
              ),
              segments: [
                GaugeSegment(
                  from: 0,
                  to: stat.toDouble(),
                  color: Colors.grey,
                  cornerRadius: Radius.zero,
                ),
                GaugeSegment(
                  from: stat.toDouble(),
                  to: 250,
                  color: Colors.grey,
                  cornerRadius: Radius.zero,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 35,
          child: Text("스탯"),
        )
      ],
    );
  }
}
