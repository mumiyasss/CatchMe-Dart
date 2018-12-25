import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final state = SettingsState();

  @override
  State createState() {
     return state;
  }
}

class SettingsState extends State<Settings> {
  String str = "Settings";

  void update() {
    setState(() {
      str = "HELLLLLLLLLLLLLLLLLO";
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
            update();
        },
        child: Center(child: Text(str)));
  }
}
