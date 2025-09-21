import 'package:flutter/material.dart';

class constants {
  final primaryColor = const Color.fromARGB(255, 0, 102, 204); // Blue feel
  final secondaryColor = const Color(0xffa1c6fd);
  final tertiaryColor = const Color(0xff205cf1);

  final blackColor = const Color(0xff000000);
  final greyColor = const Color(0xffd9dadb);

  final linearGradientBlue = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xff4da8da),
      Color(0xff0074d9)
    ], // Blue weather-like colors
    stops: [0.0, 1.0],
  );

  final Shader shader =const LinearGradient(
      colors: <Color>[Color(0xffABcff2),Color.fromARGB(255, 0, 102, 204)],
  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200, 70));
  final linearGradientPurple = const LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.bottomLeft,
    colors: <Color>[
      Color(0xff6baac1),
      Color.fromARGB(255, 220, 1, 195),
    ],
    stops: [0.0, 1.0],
  );
}
