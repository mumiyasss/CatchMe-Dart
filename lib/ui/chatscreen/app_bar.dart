import 'package:catch_me/bloc/chat_screen/chat_info/bloc.dart';
import 'package:catch_me/bloc/chat_screen/chat_info/states.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/states.dart';
import 'package:catch_me/models/Person.dart';
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

class _MenuButton extends StatelessWidget {
    @override
    build(BuildContext context) =>
        Icon(
            Icons.menu,
            size: 25,
        );
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
                if (state is ChatInfoIsLoading) {
                    return LinearProgressIndicator();
                }
                if (state is ChatInfoLoadedState) {
                    return _buildInfo(context, state.person);
                }
            },
        );
    }

    _buildInfo(BuildContext context, Person person) {
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