import 'package:catch_me/bloc/settings/bloc.dart';
import 'package:catch_me/dao/cached_db/db/Db.dart';
import 'package:catch_me/dao/cached_db/db/helpers/ChatHelper.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/ui/Widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Settings extends StatefulWidget {
    final state = SettingsState();

    final bloc = SettingsBloc();

    @override
    State createState() {
        return state;
    }
}

class SettingsState extends State<Settings> {

    @override
  void dispose() {
        // todo нужно каждый раз создавать новый observable а не сохранять его глобально чтобы
    super.dispose();
  }

    @override
    Widget build(BuildContext context) {
        return Column(
            children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 5),
                    child: StreamBuilder<Person>(
                        stream: CatchMeApp.personDao.fromUserId(CatchMeApp.userUid),
                        builder: (context, snapshot) {
                            if (snapshot.hasData) {
                                return Row(children: <Widget>[
                                    _Avatar(widget.bloc, snapshot.data),
                                    _AccountCredentials(
                                        widget.bloc, snapshot.data),
                                ],);
                            } else if (snapshot.hasError) {
                                throw Exception([snapshot.error]);
                            }
                            return CircularProgressIndicator();
                        }
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
    SettingsBloc bloc;
    Person person;

    _Avatar(this.bloc, this.person);

    @override
    __AvatarState createState() => __AvatarState();
}

class __AvatarState extends State<_Avatar> {
    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                print("on tap");
                widget.bloc.dispatch(UploadNewAvatarEvent(widget.person));
            },
            child: Widgets.profilePicture(
                context, widget.person.photoUrl, 0.27));
    }
}

class _AccountCredentials extends StatefulWidget {
    final SettingsBloc bloc;

    final Person person;

    _AccountCredentials(this.bloc, this.person);

    @override
    _AccountCredentialsState createState() => _AccountCredentialsState();
}

class _AccountCredentialsState extends State<_AccountCredentials> {

    get bloc => widget.bloc;

    @override
    void initState() {
        nameController.text = widget.person.name;
        emailController.text = widget.person.email;
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
                    onChanged: (name) {
                        bloc.dispatch(NameChangedEvents(name, widget.person));
                    },
                    style: TextStyle(color: Colors.black),
                    controller: nameController,
                    decoration: InputDecoration(
                        hintText: "Name"
                    ),),
                TextField(
                    onChanged: (email) {
                        bloc.dispatch(EmailChangedEvents(email, widget.person));
                    },
                    style: TextStyle(color: Colors.black),
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "Email"
                    ),
                )
            ],),
        );
    }
}


