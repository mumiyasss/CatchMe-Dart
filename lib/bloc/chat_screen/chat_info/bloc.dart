import 'package:bloc/bloc.dart';
import 'package:catch_me/dao/ChatDao.dart';
import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import 'states.dart';

/// Тут должен быть SingleResponsibility
/// но пока приложение слишком маленькое
class ChatBloc extends Bloc<ChatInfoEvent, ChatInfoState> {

    final DocumentReference _chatReference;

    ChatBloc(this._chatReference) {
        this.dispatch(GetChatInfo());
    }

    @override
    ChatInfoState get initialState => ChatInfoIsLoading();

    @override
    Stream<ChatInfoState> mapEventToState(ChatInfoEvent event) async* {
        if (event is GetChatInfo) {
            var snapshot = await _chatReference.get();

            yield ChatInfoLoadedState(
                (await PersonDao.instance).fromPrivateChatMembers(snapshot.data['members'])
            );
        }
    }

}
