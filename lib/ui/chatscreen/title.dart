import 'package:catch_me/models/UiPerson.dart';
import 'package:flutter/material.dart';

import '../Widgets.dart';

class TopBar extends StatelessWidget {
    final Person person;

    TopBar(this.person);

    @override
    Widget build(BuildContext context) {
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