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
    return GestureDetector(
        onTap: () {
            FirebaseAuth.instance.signOut();
        },
        child: Center(child: Text("Sign out")));
  }
}
