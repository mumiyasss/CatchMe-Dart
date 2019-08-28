import 'dart:io';

import 'package:catch_me/bloc/chat_screen/chat_info/bloc.dart';
import 'package:catch_me/bloc/chat_screen/chat_info/events.dart';
import 'package:catch_me/bloc/chat_screen/chat_info/states.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/states.dart';
import 'package:catch_me/models/Person.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Widgets.dart';

class MyAppBar extends StatefulWidget {
    final ChatBloc _bloc;

    MyAppBar(this._bloc) : assert(_bloc != null);

    @override
    _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
    bool opened = false;

    callback(bool opened) {
        setState(() {
            this.opened = opened;
            print("state changed ${this.opened}");
        });
    }

    @override
    Widget build(BuildContext context) {
        return Stack(children: <Widget>[
            AnimatedContainer(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                height: opened ? 115 : 70,
                margin: EdgeInsets.only(top: opened ? 60 : 0),
                child: MenuPanel(widget._bloc)
            ),
            Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
                margin: EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(offset: Offset(0, 5),
                        blurRadius: 5,
                        color: Color(0x09000000))
                ]),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                        _BackButton(),
                        Expanded(child: _AppBarContent(widget._bloc)),
                        _MenuButton(callback)
                    ],
                ),
            ),

        ],);
    }
}

class MenuPanel extends StatelessWidget {
    final ChatBloc _bloc;

    MenuPanel(this._bloc);

    @override
    Widget build(BuildContext context) {
        return Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1.5),
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                    BoxShadow(offset: Offset(0, 0),
                        blurRadius: 20,
                        color: Color(0x22000000))
                ]
            ),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            height: 80,
            child: _child(context),
        );
    }

    _child(BuildContext context) {
        return GestureDetector(
            onTap: () {
                showDialog(context: context, builder: (context) {
                    return Platform.isIOS ?
                    CupertinoAlertDialog(
                        title: Text("Вы уверены?"),
                        content: Text("Чат будет удалён на этом устройстве и у собеседника"),
                        actions: <Widget>[
                            FlatButton(
                                child: Text("Удалить", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w400),),
                                onPressed: () {
                                    _bloc.dispatch(DeleteChat());
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                },
                            ),
                            FlatButton(
                                child: Text("Отмена", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                },
                            ),
                        ],) :
                    AlertDialog(
                        title: Text("Вы уверены?"),
                        content: Text("Чат будет удалён на этом устройстве и у собеседника"),
                        actions: <Widget>[
                            FlatButton(
                                child: Text("Удалить", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w400),),
                                onPressed: () {
                                    _bloc.dispatch(DeleteChat());
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                },
                            ),
                            FlatButton(
                                child: Text("Отмена", style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold),),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                },
                            ),
                        ],);
                });
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Icon(Icons.delete_forever, color: Colors.red, size: 30,),
                    Text("Удалить этот чат навсегда",
                        style: TextStyle(color: Colors.red, fontSize: 20),)
                ],
            ),
        );
    }
}

class _BackButton extends StatelessWidget {
    @override
    build(BuildContext context) =>
        GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: SvgPicture.asset(
                'assets/ic_back.svg',
                width: 20,
                height: 20,
            ));
}

/// Кнопка меню
class _MenuButton extends StatefulWidget {

    final Function(bool opened) callback;

    _MenuButton(this.callback);

    @override
    __MenuButtonState createState() => __MenuButtonState();
}

class __MenuButtonState extends State<_MenuButton> {
    bool opened;

    get _animation {
        if (opened == null)
            return null;
        else
            return opened ? 'To Close' : 'To Ham';
    }

    @override
    Widget build(BuildContext context) {
        return GestureDetector(
            onTap: () {
                setState(() {
                    if (opened == null)
                        opened = false;
                    opened = !opened;
                    widget.callback(opened);
                });
            },

            child: SizedBox(
                width: 40,
                height: 30,
                child: FlareActor(
                    'assets/Ham2Close.flr',
                    animation: _animation,
                ),
            )
        );
    }
}

class _AppBarContent extends StatelessWidget {
    final ChatBloc _bloc;

    _AppBarContent(this._bloc) :
            assert(_bloc != null);

    @override
    Widget build(BuildContext context) {
        return BlocBuilder(
            bloc: _bloc,
            builder: (context, ChatInfoState state) {
                if (state is ChatInfoLoadedState) {
                    return
                        StreamBuilder(
                            stream: state.person,
                            builder: (context, personSnapshot) {
                                if (personSnapshot.hasData)
                                    return _buildInfo(
                                        context, personSnapshot.data);
                                else
                                    return LinearProgressIndicator();
                            }
                        );
                }
                return LinearProgressIndicator();
            },
        );
    }

    _buildInfo(BuildContext context, Person person) {
        assert(person != null);
        return Row(
            children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 18),
                    width: 40,
                    height: 40,
                    child: Widgets.profilePicture(
                        context, person.photoUrl, 0.01)
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text(person.name, style: TextStyle(fontSize: 20)),
                            Text(
                                'last seen at 8:30',
                                style: TextStyle(fontSize: 12),
                            )
                        ],
                    ),
                ),
            ],
        );
    }
}