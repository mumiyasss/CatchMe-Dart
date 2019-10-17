import 'package:cached_network_image/cached_network_image.dart';
import 'package:catch_me/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer extends StatelessWidget {
    final String photoUrl;

    PhotoViewer(this.photoUrl);

    @override
    Widget build(BuildContext context) {
        //SystemChrome.setEnabledSystemUIOverlays([]);
        return Scaffold(
            appBar: AppBar(
                leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.arrow_back, color: Colors.black,),
                ),
                title: Text(App.lang.photoTitle, style: TextStyle(color: Colors.black),),
                backgroundColor: Color(0xffffffff),
                brightness: Brightness.light,
            ),
            body: Hero(
                tag: photoUrl,
                child: PhotoView(
                  backgroundDecoration: BoxDecoration(color: Colors.white),
                  imageProvider: CachedNetworkImageProvider(photoUrl),

              ),
            ),
        );
    }
}
