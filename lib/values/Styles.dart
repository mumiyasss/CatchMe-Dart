import 'package:flutter/material.dart';

class Style {
  static var defaultTitle = getToolbarTextStyle(fontSize: 40, shade: 0);

  static var defaultSubtitle = getToolbarTextStyle(fontSize: 20, shade: 0x7d);

  static TextStyle getToolbarTextStyle({
    @required double fontSize,
    @required int shade
  }) =>
      TextStyle(
          fontFamily: 'sans-serif',
          fontSize: fontSize,
          color: Color.fromARGB(0xFFF, shade, shade, shade));
}
