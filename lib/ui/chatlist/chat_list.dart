import 'package:catch_me/bloc/chat_list/chat_list_bloc.dart';
import 'package:catch_me/bloc/chat_list/events.dart';
import 'package:catch_me/bloc/chat_list/states.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/ui/Widgets.dart';
import 'package:catch_me/ui/chatscreen/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:catch_me/values/Dimens.dart';
import 'package:catch_me/values/Styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'tile.dart';


class ChatList extends StatelessWidget {
  static final _chatListBloc = ChatListBloc();
  
  @override
  Widget build(BuildContext context) {

      _chatListBloc.dispatch(StartListenChatList());
      return SafeArea(
        child: BlocBuilder(
            bloc: _chatListBloc,
            builder: (BuildContext context, ChatListState state) {
                if (state is ChatsAreLoading) {
                    return Center(
                        child: CircularProgressIndicator(),
                    );
                } else if (state is NoExistingChats) {
                   return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text(
                                    "У вас пока нет сообщений.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
                                ),
                                Container(height: 7),
                                Text(
                                    "Напишите первыми😏",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                                ),
                            ]
                        ));
                } else if (state is SomeChatsExists) {
                    return _buildList(context, state.chats);
                }
            }
        ),
      );
  }

  Widget _buildList(BuildContext context, List<Chat> chats) {
    if (chats != null && chats.length != 0)
      return ListView(
        padding: EdgeInsets.only(
            left: Dimens.chatListPadding, right: Dimens.chatListPadding),
        children: chats.map((chat) => ChatTile(chat)).toList(),
      );
    else
      return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Text(
                      "У вас пока нет сообщений.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
                    ),
                    Container(height: 7,),
                    Text(
                      "Напишите первыми😏",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontSize: 20, fontWeight: FontWeight.w400),
                    ),
              ]
          ));
  }

  Widget _buildListItem(BuildContext context, Chat chat) {
    
  }

}



// TODO: dispose() in State
// TODO: ListItem as Stateless widget rewrite build method