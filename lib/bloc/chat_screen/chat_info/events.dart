import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatInfoEvent {}

/// Maybe for getting person info to app bar
class GetChatInfo extends ChatInfoEvent {
}
