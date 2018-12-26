import 'package:flutter/material.dart';
import 'package:catch_me/models/Person.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:catch_me/values/Styles.dart';

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
			"message": "Hello, how are you? I saw a lot of diffrent beautiful things",
			"time": "12:30",
			"unread": 100,
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
				padding: EdgeInsets.only(left: Dimens.chatListPadding,
						right: Dimens.chatListPadding),
				children: messages.map((message) => _buildListItem(context, message))
						.toList(),
			),
		);
	}

	Widget _buildListItem(BuildContext context, Map message) {
		var profilePhoto = message['photo'] == null ?
		profilePictureDefault : Container(
			height: 72,
			width: 72,
			decoration: BoxDecoration(
					shape: BoxShape.circle,
					image: DecorationImage(image: AssetImage('assets/hi.png'))
			),
			//child: profilePhoto
		);


		Container wrappedText(String text, TextStyle style,
				double screenPercentage) =>
				Container(
						width: MediaQuery
								.of(context)
								.size
								.width * screenPercentage,
						child: Text(
							text, style: style,
							overflow: TextOverflow.ellipsis,
							maxLines: 1,
						)
				);

		Row messageRow(Widget widget1, Widget widget2) =>
				Row(
					mainAxisSize: MainAxisSize.max,
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					children: <Widget>[
						widget1,
						widget2
					],
				);

		var name = wrappedText(message['name'], Style.chatNameStyle(), 0.5);
		var time = Text(message['time'], style: Style.lastMessageTime());
		var lastMessage = wrappedText(
				message['message'], Style.lastMessageTime(), 0.5);
		var _unread = message['unread'];
		var badge = _unread == null ? Container() : Container(
			padding: EdgeInsets.fromLTRB(7.2, 3, 7.2, 3),
			decoration: BoxDecoration(
				borderRadius: BorderRadius.all(Radius.circular(12)),
				color: Color(0xFF2196f3),
			),
			child: Text(_unread.toString(), style: Style.newMessagesCounter()),
		);

		return Container(
				child: Column(
					children: <Widget>[
						Row(
							children: <Widget>[
								profilePhoto,
								Expanded(
									child: Padding(
										padding: EdgeInsets.only(left: 18),
										child: Column(
											children: <Widget>[
												messageRow(name, time),
												Container(height: 6,),
												messageRow(lastMessage, badge)
											],
										),
									),
								),
							],
						),
						Divider()
					],
				)
		);
	}
}