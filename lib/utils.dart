import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'main.dart';

// todo: проверить работоспособность
Future<String> uploadImageToStorage(File image) async {

    var filename = Timestamp.now().seconds.toString() + CatchMeApp.userUid + image.path;

    var tempDir = (await path_provider.getTemporaryDirectory()).absolute.path;
    var targetPath = tempDir + "/temp${Timestamp.now().nanoseconds}.jpeg";
    var compressedImage = await compressAndGetFile(image, targetPath);

    final StorageReference storageRef =
    FirebaseStorage.instance.ref().child(filename);

    final StorageUploadTask uploadTask =
    storageRef.putFile(compressedImage); // add some metadata?

    final StorageTaskSnapshot downloadUrl =
    (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print('URL of uploaded image is $url');
    return url;
}

Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 65,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
}