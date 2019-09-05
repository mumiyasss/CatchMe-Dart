import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Person.dart';

abstract class ChatScreenState {}

class MessagesAreLoading extends ChatScreenState {}

class NoMessagesInThisChat extends ChatScreenState {}

class MessagesAreLoaded extends ChatScreenState {
    List<Message> messages;

    MessagesAreLoaded(this.messages);
}