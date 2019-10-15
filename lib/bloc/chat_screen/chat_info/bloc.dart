import 'package:bloc/bloc.dart';
import 'package:catch_me/bloc/chat_screen/messages_panel/bloc.dart';
import 'package:catch_me/dao/ChatDao.dart';
import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/db/exceptions.dart';
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

    Chat _chat;
    Observable<DocumentSnapshot> chatSnapshots;
    final Observable<Person> _personStream;
    final String companionId;


    ChatBloc(Person person) :
        companionId = person.userId,
        _personStream = CatchMeApp.personDao.fromUserId(person.userId) {
        startAsyncInfoUpdater(person.userId);
        this.dispatch(GetChatInfo());
    }

    startAsyncInfoUpdater(String personId) {
        try {
            _chat = CatchMeApp.chatDao.getChatWithPerson(personId);
        } on NotFound {
            print("There is no cached chat with personId $personId");
        }
        chatSnapshots =
        Observable(CatchMeApp.chatDao.getChatWithPersonFromInet(personId))
            ..listen((DocumentSnapshot chat) async {
                if (chat.data != null) {
                    _chat = await Chat.fromSnapshot(chat);
                }
            });
    }

    @override
    ChatInfoState get initialState => ChatInfoLoadedState(_personStream);

    @override
    Stream<ChatInfoState> mapEventToState(ChatInfoEvent event) async* {
        if (event is GetChatInfo) {
            yield ChatInfoLoadedState(_personStream);
        }
        if (event is DeleteChat) {
            // ToDO: dao очищает кэш и firebase, (Или остаться, чтобы выдно было что нет сообщений,
            //  но тогда надо так сделать, чтобы чат создавался только после
            //  первого сообщения.
            CatchMeApp.chatDao.deleteChat(_chat);
        }
    }

}
