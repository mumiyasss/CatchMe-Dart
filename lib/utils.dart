import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';

Future<String> takePhotoAndUploadToStorage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var filename = CatchMeApp.userUid + image.path + Timestamp.now().seconds.toString();
    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child(filename);

    final StorageUploadTask uploadTask =
    storageRef.putFile(image); // add some metadata?

    final StorageTaskSnapshot downloadUrl =
    (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print('URL of uploaded image is $url');
    return url;
}