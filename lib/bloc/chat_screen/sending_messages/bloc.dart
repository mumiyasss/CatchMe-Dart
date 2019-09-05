import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/db/exceptions.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import 'states.dart';

class SendingMessagesBloc extends Bloc<NewMessageEvent, MessageSent> {
    DocumentReference _chatReference;
    Person _person;

    SendingMessagesBloc(this._person);

    @override
    MessageSent get initialState => MessageSent();

    @override
    Stream<MessageSent> mapEventToState(NewMessageEvent event) async* {
        await startConversation(_person);
        if (event is WriteNewTextMessageEvent) {
            await _sendTextMessage(event.message);
            yield MessageSent();
        }
        if (event is AttachImageEvent) {
            var file = await ImagePicker.pickImage(source: ImageSource.gallery);
            // todo: send MESSAGE IS SENDING...
            await _sendImageMessage(file);
            yield MessageSent();
        }
    }

    _sendTextMessage(String text) async {
        Map<String, dynamic> data = {
            'text': text
        };
        _sendMessage(data);
    }

    _sendImageMessage(File image) async {
        var filename = CatchMeApp.userUid + image.path;
        final StorageReference storageRef =
        FirebaseStorage.instance.ref().child(filename);

        final StorageUploadTask uploadTask =
        storageRef.putFile(image); // add some metadata?

        final StorageTaskSnapshot downloadUrl =
        (await uploadTask.onComplete);
        final String url = (await downloadUrl.ref.getDownloadURL());
        print('URL Is $url');
        Map<String, dynamic> data = {
            'image': url
        };
        _sendMessage(data);
    }

    _sendMessage(Map<String, dynamic> data) async {
        assert(data['text'] != null || data['image'] != null);

        data['author'] = CatchMeApp.userUid;
        data['timestamp'] = Timestamp.now(); // Todo: cloud function

        _chatReference.collection('messages').add(data);
        _chatReference.updateData({
            'lastMessageAuthorId': CatchMeApp.userUid,
            'lastMessageText': data['text'] ?? '🏞 Picture', // TODO: locale
            'lastMessageTime': Timestamp.now() // Todo: cloud function
        });
    }

    startConversation(Person person) async {
        var companionId = person.userId;
        Chat chat;
        try {
            chat = CatchMeApp.chatDao.getChatWithPerson(companionId);
        } on NotFound {
            final tempMessages = List<String>();
            tempMessages.add("Conversation Started");
            await Firestore.instance
                .collection('chats')
                .document(chatName(companionId, CatchMeApp.userUid))
                .setData({
                'members': [companionId, CatchMeApp.userUid],
                'lastMessageText':
                (await (await PersonDao.instance)
                    .fromUserId(CatchMeApp.userUid)
                    .first).name +
                    " создал",
                'lastMessageAuthorId': CatchMeApp.userUid,
                'lastMessageTime': Timestamp.now(),
            });

            chat = await Chat.fromSnapshot(await CatchMeApp.chatDao
                .getChatWithPersonFromInet(companionId)
                .first);
        }

        _chatReference = chat.reference;
    }

    String chatName(String str1, String str2) {
        return str1.compareTo(str2) > 0 ? str1 + str2 : str2 + str1;
    }
}
