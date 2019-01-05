import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Widgets {
  static Widget profilePicture(
      BuildContext context, String photoUrl, double sizeProportion) {
    double size = MediaQuery.of(context).size.width * sizeProportion;
    return photoUrl == null
        ? SvgPicture.asset(
            'assets/profile.svg',
            width: size,
            height: size,
          )
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(photoUrl))),
            //child: profilePhoto
          );
  }
}
