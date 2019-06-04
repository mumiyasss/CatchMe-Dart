import 'package:catch_me/models/Chat.dart';

abstract class ChatListState {}

class ChatsAreLoading extends ChatListState {}

class NoExistingChats extends ChatListState {}

class SomeChatsExists extends ChatListState {
    List<Chat> chats;

    /// This state must be always initialized with not empty chat list 
    SomeChatsExists(this.chats) :
            assert(chats != null),
            assert(chats.isNotEmpty);
}
