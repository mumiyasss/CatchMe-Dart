import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'main.dart';

Future<String> uploadImageToStorage(File image) async {

    var filename = Timestamp.now().seconds.toString() + App.userUid + image.path;

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

String toReadableTime(Timestamp timestamp, {bool withArticle = false}) {
    String plusZero(int x) => "${x < 10 ? "0$x" : x}";

    var date = timestamp.toDate();


    if (DateTime.now().year != date.year) {
        return "${withArticle ? "on ": ""}${plusZero(date.day)}.${plusZero(date.month)}.${date.year % 2000}";
    } else if (DateTime.now().difference(date) > Duration(days: 7)) {
        return "${withArticle ? "on ": ""}${plusZero(date.day)}.${plusZero(date.month)}";
    } else if (DateTime.now().weekday != date.weekday && !withArticle) {
        switch (date.weekday) {
            case DateTime.monday: return "Mon";
            case DateTime.tuesday: return "Tue";
            case DateTime.wednesday: return "Wed";
            case DateTime.thursday: return "Thu";
            case DateTime.friday: return "Fri";
            case DateTime.saturday: return "Sat";
            case DateTime.sunday: return "Sun";
        }
        throw Exception("no such weekday");
    } else if (DateTime.now().weekday != date.weekday && withArticle) {
        switch (date.weekday) {
            case DateTime.monday: return "on Monday";
            case DateTime.tuesday: return "on Tuesday";
            case DateTime.wednesday: return "on Wednesday";
            case DateTime.thursday: return "on Thursday";
            case DateTime.friday: return "on Friday";
            case DateTime.saturday: return "on Saturday";
            case DateTime.sunday: return "on Sunday";
        }
        throw Exception("no such weekday");
    } else {
        return "${withArticle ? "at ": ""}${plusZero(date.hour)}:${plusZero(date.minute)}";
    }
}