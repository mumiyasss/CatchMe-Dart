import 'dart:io';

abstract class NewMessageEvent {}

class WriteNewTextMessageEvent extends NewMessageEvent {
    final String message;

    WriteNewTextMessageEvent(this.message);
}

class AttachImageEvent extends NewMessageEvent { }



