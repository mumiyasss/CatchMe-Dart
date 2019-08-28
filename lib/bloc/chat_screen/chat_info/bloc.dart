import 'package:bloc/bloc.dart';
import 'package:catch_me/dao/ChatDao.dart';
import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import 'states.dart';

/// Тут должен быть SingleResponsibility
/// но пока приложение слишком маленькое
class ChatBloc extends Bloc<ChatInfoEvent, ChatInfoState> {

    final Chat _chat;

    ChatBloc(this._chat) {
        this.dispatch(GetChatInfo());
    }

    @override
    ChatInfoState get initialState =>
        ChatInfoLoadedState(Observable.just(_chat.companion));

    @override
    Stream<ChatInfoState> mapEventToState(ChatInfoEvent event) async* {
        if (event is GetChatInfo) {
            yield ChatInfoLoadedState(
                CatchMeApp.personDao.fromUserId(_chat.companion.userId)
            );
        }
        if (event is DeleteChat) {
            // ToDO: dao очищает кэш и firebase, (Или остаться, чтобы выдно было что нет сообщений,
            //  но тогда надо так сделать, чтобы чат создавался только после
            //  первого сообщения.
            CatchMeApp.chatDao.deleteChat(_chat);
        }
    }


}
