import 'dart:async';

import 'package:catch_me/bloc/chat_list/events.dart';
import 'package:catch_me/bloc/chat_list/states.dart';
import 'package:catch_me/dao/ChatDao.dart';
import 'package:catch_me/dao/cached_db/cached_db.dart';

import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {

    @override
    ChatListState get initialState {
        return ChatsAreLoading();
    }

    @override
    Stream<ChatListState> mapEventToState(ChatListEvent event) async* {
        if (event is StartListenChatList) {
            var dao = await ChatDao.instance;

            // Проблема в том что кэширование чатов не позволяет
            // раскрыть свой потенциал так как не реализовано кэширование
            // людей.
            await for (var chatList in dao.getAll()) {
                yield chatList.isNotEmpty
                    ? SomeChatsExists(chatList)
                    : NoExistingChats();
            }
        }
    }

}
