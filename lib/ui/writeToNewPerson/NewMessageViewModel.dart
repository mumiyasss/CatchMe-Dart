import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessageViewModel {
    Stream<QuerySnapshot> get _usersCollection =>
        Firestore.instance.collection('users').snapshots();

    Stream<List<Person>> get users async* {
        await for (var users in _usersCollection) {
            yield users.documents
                .map((userSnapshot) => Person.fromSnapshot(userSnapshot))
                .toList();
        }
    }

    // 1) вынести логику создания и проверки чата в блок который посылает сообщения
    // 2) если сообщений еще нет, поставить заглушку что и их нет на экран, проверить через Obserbable
    // 3) возможно все таки нужно создать bloc для writeToNewPerson, но теперь функциональность
    // его viewModel поглотит блок для отправки сообщений.
    Future<DocumentReference> startNewConversation(String companionId) async {
        var chat = await Firestore.instance
            .document('chats/' + chatName(companionId, App.userUid))
            .get();

        if (chat.exists == false) {
            final tempMessages = List<String>();
            tempMessages.add("Conversation Started");
            Firestore.instance
                .collection('chats')
                .document(chatName(companionId, App.userUid))
                .setData({
                'members' : [companionId, App.userUid],
                'lastMessageText':
                (await (await PersonDao.instance).fromUserId(App.userUid).first).name +
                    " создал",
                'lastMessageAuthorId': App.userUid,
                'lastMessageTime': Timestamp.now(),
            });
            var newChat = await Firestore.instance
                .document('chats/' + chatName(companionId, App.userUid))
                .get();
            return newChat.reference;
        } else {
            print(chat.documentID);
            return chat.reference;
        }
    }

    String chatName(String str1, String str2) {
        return str1.compareTo(str2) > 0 ? str1 + str2 : str2 + str1;
    }
}
