abstract class NewMessageEvent {}

class WriteNewTextMessageEvent extends NewMessageEvent {
    final String message;

    WriteNewTextMessageEvent(this.message);
}