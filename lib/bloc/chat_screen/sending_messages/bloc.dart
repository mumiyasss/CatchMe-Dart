import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:catch_me/dao/PersonDao.dart';
import 'package:catch_me/dao/cached_db/db/exceptions.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Chat.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Person.dart';
import 'package:catch_me/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';

import 'events.dart';
import 'states.dart';

class SendingMessagesBloc extends Bloc<NewMessageEvent, ImagesAreUploading> {
    DocumentReference _chatReference;
    Person _person;
    static var _uploadingImagesQuantity = 0;

    static final imageQuantityStreamController = StreamController<int>
        .broadcast(sync: true)
        ..add(_uploadingImagesQuantity);

    SendingMessagesBloc(this._person);

    @override
    ImagesAreUploading get initialState => ImagesAreUploading(quantity: 0);

    @override
    Stream<ImagesAreUploading> mapEventToState(NewMessageEvent event) async* {
        await _startConversation(_person);
        print(_chatReference);
        if (event is WriteNewTextMessageEvent) {
            // он создает новый chat screen после photo select
            //imageQuantityStreamController.add(1);
//            yield ImagesAreUploading(quantity: 1);
            await _sendTextMessage(event.message);
            //imageQuantityStreamController.add(0);

        }
        if (event is AttachImageEvent) {
            var file = await ImagePicker.pickImage(source: ImageSource.gallery);
            if (file != null) {
                imageQuantityStreamController.add(++_uploadingImagesQuantity);
                print(" in mapevent" + _uploadingImagesQuantity.toString());
                await _sendImageMessage(file);
                imageQuantityStreamController.add(--_uploadingImagesQuantity);
            }
        }
    }

    _sendTextMessage(String text) async {
        Map<String, dynamic> data = {
            'text': text
        };
        _sendMessage(data);
    }

    _sendImageMessage(File image) async {
        String url = await uploadImageToStorage(image);
        Map<String, dynamic> data = {
            'image': url
        };
        _sendMessage(data);
    }


    _sendMessage1(Map<String, dynamic> data) async {
        assert(data['text'] != null || data['image'] != null);

        var mapToSend = Map<String, dynamic>();
        mapToSend['chatPath'] = _chatReference.path;
        mapToSend['companionUid'] = _person.userId;
        mapToSend['message'] = data;

        final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
            functionName: 'sendMessage',
        );
        var resp = await callable.call(mapToSend);
        print("Response on sendMessage $resp");
    }

    _sendMessage(Map<String, dynamic> data) async {
        assert(data['text'] != null || data['image'] != null);

        data['author'] = App.userUid;
        data['timestamp'] = Timestamp.now(); // Todo: cloud function

        data['chatPath'] = _chatReference.path;
        data['companionUid'] = _person.userId;

        _chatReference.collection('messages').add(data);
        _chatReference.updateData({
            'lastMessageAuthorId': App.userUid,
            'lastMessageText': data['text'] ?? '🏞 Picture',
            'lastMessageTime': Timestamp.now() // Todo: cloud function
        });
    }

    _startConversation(Person person) async {
        var companionId = person.userId;
        Chat chat;
        try {
            chat = App.chatDao.getChatWithPerson(companionId);
        } on NotFound {
            final tempMessages = List<String>();
            tempMessages.add("Conversation Started");
            await Firestore.instance
                .collection('chats')
                .document(chatName(companionId, App.userUid))
                .setData({
                'members': [companionId, App.userUid],
                'lastMessageText':
                (await (await PersonDao.instance)
                    .fromUserId(App.userUid)
                    .first).name +
                    " создал",
                'lastMessageAuthorId': App.userUid,
                'lastMessageTime': Timestamp.now(),
            });

            chat = await Chat.fromSnapshot(await App.chatDao
                .getChatWithPersonFromInet(companionId)
                .first);
        }

        _chatReference = chat.reference;
    }

    String chatName(String str1, String str2) {
        return str1.compareTo(str2) > 0 ? str1 + str2 : str2 + str1;
    }
}
