import 'package:fcmobile_squad_maker/config/assets.dart';
import 'package:fcmobile_squad_maker/config/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "홈",
          style: CustomTextStyle.appbarTitle,
        ),
        centerTitle: false,
        actions: [
          IconButton(icon:Icon(IconSrc.bell_alt), onPressed: () {  },),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Text("home").animate().fade().scale(delay: 1.seconds, duration: 1.seconds),
            Column(
              children: ["Hello", "World", "Goodbye"]
                  .map((text) => Text(text).animate().fade(duration: 400.ms))
                  .toList(),
            ),
            Text("Hello World").animate().custom(
              duration: 2000.ms,
              builder: (context, value, child) => Container(
                color: Color.lerp(Colors.red, Colors.blue, value),
                child: child,
              ),
            ),
            Text("Animated Text", style: TextStyle(fontSize: 20),).animate().custom(
              builder: (context, value, child) => ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Color.lerp(Colors.red, Colors.blue, value)!,
                  BlendMode.srcIn,
                ),
                child: child,
              ),
            ),
            Text(
              "TEST",
              style: CustomTextStyle.loginTitle
            ).animate(adapter: ValueAdapter(0.5)).shimmer(
              colors: [
                const Color(0xFFFFFF00),
                const Color(0xFF00FF00),
                const Color(0xFF00FFFF),
                const Color(0xFF0033FF),
                const Color(0xFFFF00FF),
                const Color(0xFFFF0000),
                const Color(0xFFFFFF00),
              ]
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                .saturate(delay: 1.seconds, duration: 2.seconds)
                .then() // set baseline time to previous effect's end time
                .tint(color: const Color(0xFF80DDFF))
          ],
        ),
      ),
    );
  }
}
