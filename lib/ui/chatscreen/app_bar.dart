import 'package:catch_me/bloc/chat_screen/chat_info/bloc.dart';
import 'package:catch_me/bloc/chat_screen/chat_info/events.dart';
import 'package:catch_me/bloc/chat_screen/chat_info/states.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/states.dart';
import 'package:catch_me/models/Person.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Widgets.dart';

class MyAppBar extends StatelessWidget {
    final ChatBloc _bloc;

    MyAppBar(this._bloc) : assert(_bloc != null);

    @override
    Widget build(BuildContext context) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 8),
            margin: EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(offset: Offset(0, 2),
                    blurRadius: 5,
                    color: Color(0x22000000))
            ]),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    _BackButton(),
                    Expanded(child: _AppBarContent(_bloc)),
                    _MenuButton()
                ],
            ),);
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
//    @override
//    build(BuildContext context) =>
//        Icon(
//            Icons.menu,
//            size: 25,
//        );
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