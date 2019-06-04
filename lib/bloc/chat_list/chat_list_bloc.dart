import 'dart:async';

import 'package:catch_me/bloc/chat_list/events.dart';
import 'package:catch_me/bloc/chat_list/states.dart';

import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc/bloc.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {

    @override
    ChatListState get initialState => ChatsAreLoading();

    @override
    Stream<ChatListState> mapEventToState(ChatListEvent event) async* {
        if (event is StartListenChatList) {
            _listeningStatus = true;
            await for (var chatList in _chatListsStream) {
                if (_listeningStatus == false) break;
                yield chatList.isEmpty
                    ? NoExistingChats()
                    : SomeChatsExists(chatList);
            }
        } else if (event is StopListenChatList) {
            _listeningStatus = false;
        }
    }

    Stream<List<Chat>> get _chatListsStream async* {
        await for (var chats in _chatsCollection) {
            var tempChatList = List<Chat>();
            for (var chatSnapshot in chats.documents)
                tempChatList.add(await Chat.fromSnapshot(chatSnapshot));
            yield tempChatList;
        }
    }

    /// Initial state
    bool _listeningStatus = false;

    final _chatsCollection = Firestore.instance
        .collection('chats')
        .where('members', arrayContains: CatchMeApp.userUid)
        .orderBy(
        'lastMessageTime', descending: true) // ??? Query requires Index.
        .snapshots();
}
