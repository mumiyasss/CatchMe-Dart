import 'package:catch_me/dao/cached_db/db/Db.dart';
import 'package:catch_me/dao/cached_db/db/helpers/ChatHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
    final state = SettingsState();

    @override
    State createState() {
        return state;
    }
}

class SettingsState extends State<Settings> {
    var _currentStyle = SystemChrome.latestStyle;

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                Center(
                    child: RaisedButton(
                        elevation: 4,
                        onPressed: () =>
                            Db.instance.then((db) => db.delete(chatTable)),
                        child: Text("Удалить таблицу",
                            style: TextStyle(color: Colors.white),),
                        color: Colors.red,
                    )),

                Center(
                    child: RaisedButton(
                        elevation: 4,
                        onPressed: () {
                            FirebaseAuth.instance.signOut();
                        },
                        child: Text(
                            "Выйти", style: TextStyle(color: Colors.white),),
                        color: Colors.blue,
                    )),
            ],
        );
    }
}
