import 'package:flutter/material.dart';
import 'package:catch_me/models/Person.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatList extends StatelessWidget {

	final people = [
		Person("8", "James Smith"),
		Person("8", "Olga Odintsova"),
		Person("8", "James Bond"),
		Person("8", "Marshal Erikson"),
	];


	static final profilePicture1 = AssetImage('assets/hi.png');
	final profilePictureDefault = SvgPicture.asset(
		'assets/profile.svg', width: 72, height: 72,);

	final messages = [
		{
			"name": "Kolya Grebnev",
			"message": "Hello, how are you?",
			"time": "12:30",
			"unread": 3,
			"photo": null,
		},
		{
			"name": "James Smith",
			"message": "I'm fine, thank you",
			"time": "12:21",
			"unread": null,
			"photo": profilePicture1
		},

	];

	@override
	Widget build(BuildContext context) {
		return SafeArea(
		  child: ListView(
		  	children: messages.map((message) => _buildListItem(context, message))
		  			.toList(),
		  ),
		);
	}

	Widget _buildListItem(BuildContext context, Map message) {
		var profilePhoto = message['photo'] == null ?
		profilePictureDefault
				: Image.asset('assets/hi.png', width: 72, height: 72);


		var nameAndMessage = Column(
			children: <Widget>[
				Text(message['name']),
				Text(message['message']),
			],
		);

		var timeAndUnread = Column (
				children: <Widget>[
					Text(message['time']),
					Text(message['unread'] == null ? "" : message['unread'].toString()),
				],
		);


		return Container(
				child: Row(
					children: <Widget>[
						profilePhoto,
						nameAndMessage,
						timeAndUnread
					],
				)
		);
	}
}