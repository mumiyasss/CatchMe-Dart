import 'package:flutter/material.dart';

class Styles {
  static final mainTheme = ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.blue,
      platform: TargetPlatform.iOS
  );
  static final darkTheme = mainTheme.copyWith();

  static var defaultTitle = getToolbarTextStyle(fontSize: 40, shade: 0);
  static var defaultSubtitle = getToolbarTextStyle(fontSize: 20, shade: 0x7d);

  static TextStyle getToolbarTextStyle(
          {@required double fontSize, @required int shade}) =>
      TextStyle(
          fontFamily: 'sans-serif',
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Color.fromARGB(0xFFF, shade, shade, shade));

  static TextStyle chatNameStyle() => TextStyle(
      fontFamily: 'sans-serif-light',
      fontSize: 22,
      fontStyle: FontStyle.italic,
      color: Color(0xFF0e0e0e));

  static TextStyle messageInChatListStyle() => TextStyle(
      fontFamily: 'sans-serif-light',
      fontSize: 15,
      fontStyle: FontStyle.normal,
      color: Color(0xFF0e0e0e));

  static TextStyle lastMessageTime() => TextStyle(
      fontFamily: 'sans-serif-light',
      fontSize: 15,
      fontStyle: FontStyle.normal,
      color: Color(0xFF0e0e0e));

  static TextStyle newMessagesCounter() => TextStyle(
      fontFamily: 'sans-serif-light',
      fontSize: 15,
      fontStyle: FontStyle.normal,
      color: Color(0xFFFFFFFF));
}
