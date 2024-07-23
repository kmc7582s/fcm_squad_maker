import 'package:fcmobile_squad_maker/config/assets.dart';
import 'package:fcmobile_squad_maker/config/color.dart';
import 'package:fcmobile_squad_maker/pages/squadmaker/search_player.dart';
import 'package:flutter/material.dart';

class FW extends StatelessWidget {
  const FW({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(IconSrc.add,color: Palette.fwColor),
        ),
        const Text(
          "FW",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Palette.fwColor
          ),
        ),
      ],
    );
  }
}

class MF extends StatelessWidget {
  const MF({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(IconSrc.add,color: Palette.mfColor),
        ),
        const Text(
          "MF",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Palette.mfColor
          ),
        ),
      ],
    );
  }
}

class DF extends StatelessWidget {
  const DF({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(IconSrc.add,color: Palette.dfColor),
        ),
        const Text(
          "DF",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Palette.dfColor
          ),
        ),
      ],
    );
  }
}

class GK extends StatelessWidget {
  const GK({super.key, required player});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(IconSrc.add,color: Palette.gkColor),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Search())),
        ),
        Text(
          "GK",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Palette.gkColor
          ),
        ),
      ],
    );
  }
}




