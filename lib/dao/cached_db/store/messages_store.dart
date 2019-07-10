import 'package:catch_me/models/Message.dart';
import 'package:flutter/widgets.dart';

class MessagesStore {

    /// Caching messages
    Map<String, List<Message>> _messages;

    List<Message> getMessages({@required String chatPath}) {
        return _messages[chatPath];
    }

    putMessages({@required String chatPath, @required List<Message> messages}) {
        assert(chatPath != null);
        assert(messages != null);
        _messages[chatPath] = messages;
    }
}