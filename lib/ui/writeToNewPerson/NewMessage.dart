import 'package:catch_me/models/Person.dart';
import 'package:catch_me/ui/Widgets.dart';
import 'package:catch_me/ui/chatscreen/ChatScreen.dart';
import 'package:catch_me/ui/writeToNewPerson/NewMessageViewModel.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:flutter/material.dart';

NewMessageViewModel viewModel = NewMessageViewModel();

class NewMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<List<Person>>(
          stream: viewModel.users,
          builder: (context, snapshot) => snapshot.hasData
              ? _buildList(context, snapshot.data)
              : CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildList(context, List<Person> persons) {
    return Column(children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(25),
        height: 90,
        child: Text(
          "All Users",
          style: TextStyle(
              fontSize: 50, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      Flexible(
        child: ListView(
          children: persons
              .map((person) => _buildPersonItem(context, person))
              .toList(),
        ),
      ),
    ]);
  }

  Widget _buildPersonItem(context, Person person) {
    return GestureDetector(
      onTap: () {
        viewModel.startNewConversation(person.userId).then((chatReference) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen(chatReference)),
          );
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        child: Row(
          children: <Widget>[
            Widgets.profilePicture(context, person.photoUrl, 0.12),
            Container(
              width: 15,
            ),
            Text(
              person.name,
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
