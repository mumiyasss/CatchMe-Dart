import 'package:flutter/material.dart';
import 'package:catch_me/chatlist/ChatList.dart';
import 'package:catch_me/settings/Settings.dart';
import 'AppBar.dart';

class MainPage extends StatefulWidget {
  final pageView = PageView(
    children: <Widget>[
      ChatList(), Settings(),
    ],
    controller: PageController(),
  );

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  MyAppBar appBar;

  @override
  Widget build(BuildContext context) {
    appBar = MyAppBar(widget.pageView.controller);

    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: <Widget>[appBar, widget.pageView],
      ),
    ));
  }
}
