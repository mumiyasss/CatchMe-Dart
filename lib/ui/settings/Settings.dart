import 'package:catch_me/dao/cached_db/db/Db.dart';
import 'package:catch_me/dao/cached_db/db/helpers/ChatHelper.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/ui/Widgets.dart';
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

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 5),
                    child: Row(children: <Widget>[
                        _Avatar(),
                        _NameRename(),
                    ],
                    ),
                ),

                Container(height: 80,),

                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            child: RaisedButton(
                                elevation: 4,
                                onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                },
                                child: Text(
                                    "Выйти",
                                    style: TextStyle(color: Colors.white),),
                                color: Colors.blue,
                            ),
                        )
                    ],
                ),
            ],
        );
    }
}

class _Avatar extends StatefulWidget {
    @override
    __AvatarState createState() => __AvatarState();
}

class __AvatarState extends State<_Avatar> {
    @override
    Widget build(BuildContext context) {
        return Widgets.profilePicture(context, CatchMeApp.userPhotoUrl, 0.25);
    }
}

class _NameRename extends StatefulWidget {
    @override
    __NameRenameState createState() => __NameRenameState();
}

class __NameRenameState extends State<_NameRename> {

    @override
    void initState() {
        nameController.text = CatchMeApp.userName;
        emailController.text = CatchMeApp.userEmail;

        super.initState();
    }

    final nameController = TextEditingController();
    final emailController = TextEditingController();

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: EdgeInsets.only(left: 20),
            width: MediaQuery
                .of(context)
                .size
                .width * 0.50,
            height: 90,
            child: Column(children: <Widget>[
                TextField(
                    style: TextStyle(color: Colors.black),
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Name"
                    ),),
                TextField(
                    style: TextStyle(color: Colors.black),
                    controller: emailController,
                    decoration: InputDecoration(

                    hintText: "Email"
                ),)
            ],),
        );
    }
}


