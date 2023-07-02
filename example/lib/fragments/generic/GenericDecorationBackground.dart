
import 'package:flutter/cupertino.dart';

class GenericDecorationBackground {
  static BoxDecoration Dark = BoxDecoration(
      gradient:  RadialGradient(
        center: Alignment(0.0, 2.0), // bottom center
        radius: 2,
        colors: [
          Color(0xFFFFFFFF),
          Color(0xFFD0D0FF),
        ],
      )
  );
}
