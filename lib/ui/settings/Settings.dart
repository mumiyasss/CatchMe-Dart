import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  final state = SettingsState();

  @override
  State createState() {
    return state;
  }
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: RaisedButton(
          elevation: 4,
      onPressed: () => FirebaseAuth.instance.signOut(),
      child: Text("Выйти", style: TextStyle(color: Colors.white),),
      color: Colors.blue,
    ));
  }
}
