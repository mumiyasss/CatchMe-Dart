import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:catch_me/main.dart';
import 'package:catch_me/models/Message.dart';
import 'package:catch_me/models/Person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'events.dart';
import 'states.dart';

class SendingMessagesBloc extends Bloc<NewMessageEvent, MessageSent> {
    final DocumentReference _chatReference;

    SendingMessagesBloc(this._chatReference);

    @override
    MessageSent get initialState => MessageSent();

    @override
    Stream<MessageSent> mapEventToState(NewMessageEvent event) async* {
        if (event is WriteNewTextMessageEvent) {
            await _sendTextMessage(event.message);
            yield MessageSent();
        }
        if (event is AttachImageEvent) {
            _sendImageMessage(await ImagePicker.pickImage(source: ImageSource.gallery));
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
}
