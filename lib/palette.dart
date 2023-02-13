import 'package:flutter/material.dart';

class Palette {
  Color bgColor = Color.fromRGBO(21, 21, 21, 1);
  Color bgLite = Color.fromRGBO(27, 27, 27, 1);
  Color bgLite2 = Color.fromRGBO(35, 35, 35, 1);
  static Color primaryColor = Color.fromRGBO(214, 19, 85, 1);

  List<Color> colors = [
    Color.fromRGBO(214, 19, 85, 1),
    Color.fromRGBO(255, 234, 32, 1),
    Color.fromRGBO(234, 4, 126, 1),
    Color.fromRGBO(111, 237, 214, 1),
    Color.fromRGBO(248, 6, 204, 1),
    Color.fromRGBO(255, 141, 41, 1),
    Color.fromRGBO(255, 99, 99, 1),
    Color.fromRGBO(255, 171, 118, 1),
    Color.fromRGBO(255, 253, 162, 1),
    Color.fromRGBO(186, 255, 180, 1),
    Color.fromRGBO(6, 255, 0, 1),
    Color.fromRGBO(185, 131, 255, 1),
    Color.fromRGBO(148, 179, 253, 1),
    Color.fromRGBO(148, 218, 255, 1),
    Color.fromRGBO(153, 254, 255, 1),
    Color.fromRGBO(29, 185, 195, 1),
    Color.fromRGBO(251, 122, 252, 1)
  ];

  void setColor(int index) {
    primaryColor = colors[index];
  }
}
