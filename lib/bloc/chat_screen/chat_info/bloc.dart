import 'package:bloc/bloc.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'events.dart';
import 'states.dart';


/// Тут должен быть SingleResponsibility
/// но пока приложение слишком маленькое
class ChatBloc extends Bloc<ChatInfoEvent, ChatInfoState> {

    final DocumentReference _chatReference;
    ChatBloc(this._chatReference) {
        this.dispatch(GetChatInfo());
    }
    
    // Todo: make chat info dao

    @override
    ChatInfoState get initialState => ChatInfoIsLoading();

    @override
    Stream<ChatInfoState> mapEventToState(ChatInfoEvent event) async* {
        if (event is GetChatInfo) {
            yield ChatInfoLoadedState(await _getChatInfo());
        }
    }

    Future<Person> _getChatInfo() async {
        var snapshot = await _chatReference.get();
        return await Person.fromPrivateChatMembers(snapshot.data['members']);
    }
}
